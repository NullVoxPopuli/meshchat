# frozen_string_literal: true
module Meshchat
  module Network
    module Global
      class RelayPool
        # This channel is determine by the server, see
        # https://github.com/NullVoxPopuli/mesh-relay/blob/master/app/channels/mesh_relay_channel.rb
        CHANNEL = 'MeshRelayChannel'

        attr_accessor :_message_dispatcher
        attr_accessor :_active_relay
        attr_accessor :_known_relays, :_available_relays

        def initialize(message_dispatcher)
          @_message_dispatcher = message_dispatcher
          @_known_relays = APP_CONFIG.user['relays'] || []
          @_available_relays = APP_CONFIG.user['relays'] || []

          find_initial_relay if @_known_relays.present?
        end

        # TODO: add logic for just selecting the first available relay.
        #       we only need one connection.
        # @return [Array] an array of action cable clients
        def find_initial_relay
          url = _known_relays.first
          @_active_relay = Relay.new(url, _message_dispatcher)
        end

        # @param [Hash] payload - the message payload
        def send_payload(payload)
          return if _active_relay.blank?
          _active_relay.perform('chat', payload)
        end
      end
    end
  end
end
