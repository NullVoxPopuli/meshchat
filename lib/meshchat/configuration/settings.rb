# frozen_string_literal: true
module Meshchat
  module Configuration
    class Settings < HashFile
      FILENAME = 'settings.json'

      DEFAULT_SETTINGS = {
        'alias' => '',
        'port' => '8009',
        'ip' => 'localhost',
        'uid' => '',
        'publickey' => '',
        'relays' => [
          'wss://mesh-relay-in-us-1.herokuapp.com',
          'wss://mesh-relay-us-2.herokuapp.com'
        ]
      }.freeze

      def debug?
        %w(true 1 yes y t).include?(self['debug'].try(:downcase))
      end

      def identity_as_json
        {
          'alias' => self['alias'],
          'location' => location,
          'uid' => self['uid'],
          'publickey' => public_key
        }
      end

      def share
        data = identity_as_json.to_json

        filename = "#{identity_as_json['alias']}.json"
        File.open(filename, 'w') { |f| f.syswrite(data) }
        Display.info "#{filename} written..."
      end

      def keys_exist?
        public_key.present? && private_key.present?
      end

      def uid_exists?
        self['uid'].present?
      end

      def public_key
        self['publickey']
      end

      def private_key
        self['privatkey']
      end

      # generates 32 bytes
      def generate_uid
        self['uid'] = SecureRandom.hex(32)
        Display.success 'new uid set'
      end

      def generate_keys
        @key_pair = OpenSSL::PKey::RSA.new(2048)
        self['publickey'] = @key_pair.public_key.to_pem
        self['privatekey'] = @key_pair.to_pem
        Display.success 'new keys generated'
      end

      def key_pair
        if !@key_pair && keys_exist?
          @key_pair = OpenSSL::PKey::RSA.new(self['privatekey'] + self['publickey'])
        end
        @key_pair
      end

      def identity
        "#{self['alias']}@#{location}##{self['uid']}"
      end

      def location
        "#{self['ip']}:#{self['port']}"
      end

      def initialize
        @default_settings = DEFAULT_SETTINGS
        @filename = FILENAME
        super
      end

      def valid?
        errors.empty?
      end

      def errors
        messages = []
        messages << 'must have an alias' unless self['alias'].present?
        messages << 'must have ip set' unless self['ip'].present?
        messages << 'must have port set' unless self['port'].present?
        messages << 'must have uid set' unless self['uid'].present?
        messages
      end

      def is_complete?
        valid? && self['privatekey'] && self['publickey']
      end
    end
  end
end
