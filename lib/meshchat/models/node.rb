# frozen_string_literal: true
module Meshchat
  class Node < ActiveRecord::Base
    IPV4_WITH_PORT = /((?:(?:^|\.)(?:\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])){4})(:\d*)?/
    # http://rubular.com/r/WYT09ptct3
    DOMAIN_WITH_PORT = /(https?:\/\/)?([\da-z\.-]+)\.?([a-z\.]{2,6})([\/\w \.-]*)*[^\/](:\d*)?/

    validates :alias_name,
      :location,
      :public_key, presence: true

    validates :uid, presence: true, uniqueness: true

    # ipv4 with port
    validates_format_of :location, with: lambda { |e|
      location = e.location || ''
      location.include?('//') || location.include?('localhost') ?
        DOMAIN_WITH_PORT :
        IPV4_WITH_PORT
    }

    scope :on_local_network, -> { where(on_local_network: true) }
    scope :on_relay, -> { where(on_relay: true) }
    scope :online, -> { on_local_network.or(on_relay) }

    class << self
      def sha_preimage
        all.map(&:public_key).sort.join(',')
      end

      def as_sha512
        digest = Digest::SHA512.new
        digest.hexdigest sha_preimage
      end

      def as_json
        # must also include ourselves
        # so that we can pass our own public key
        # to those who don't have it
        others = all.map(&:as_json)
        me = APP_CONFIG.user.identity_as_json
        others << me
      end

      def from_json(json)
        new(
          alias_name: json['alias'],
          location_on_network: json['location'],
          uid: json['uid'],
          public_key: json['publickey']
        )
      end

      def public_key_from_uid(uid)
        find_by_uid(uid).try(:public_key)
      end

      # @param [Array] theirs array of hashes representing node entries
      # @return [Array<-,+>] nodes only we have, and nodes only they have
      def diff(theirs)
        ours = as_json
        we_only_have = ours - theirs
        they_only_have = theirs - ours

        [we_only_have, they_only_have]
      end

      def import_from_file(filename)
        f = File.read(filename)
        hash = JSON.parse(f)
        n = from_json(hash)
        n.save
        n
      rescue => e
        Display.alert e.message
      end

      # Try to find the node, given a location, or uid
      #
      # TODO: do we want to also be able to find by relay address?
      #       - this would be non-unique
      #       - maybe finding should only happen via UID
      # @param [String] location - the local network address
      # @param [String] uid - the node's UID
      # @param [Node] node - the node
      # @return [Node]
      def for(location: nil, uid: nil, node: nil)
        unless node
          node = Node.find_by_location_on_network(location) if location
          node = Node.find_by_uid(uid) if uid && !node
        end

        unless node && node.valid?
          msg =  I18n.t('node.not_found', name: location || uid || '')
          return Display.alert msg
        end

        node
      end
    end

    def ==(other)
      result = false

      if other.is_a?(Hash)
        result = as_json.values_at(*other.keys) == other.values
      end

      result || super
    end

    def online
      on_relay? || on_local_network?
    end
    alias_method :online?, :online

    def location
      return location_of_relay if on_relay?
      location_on_network
    end

    def location_is_web_socket?
      location.match(/wss?/).present?
    end

    def as_json
      {
        'alias' => alias_name,
        'location' => location_on_network,
        'uid' => uid,
        'publickey' => public_key
      }
    end

    def as_info
      "#{alias_name}@#{location}"
    end
  end
end
