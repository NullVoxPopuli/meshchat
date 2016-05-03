# frozen_string_literal: true
module Meshchat
  module Network
    module Remote
      class Connection
        attr_reader :_message_factory, :_message_dispatcher
        attr_reader :_relay_pool

        def initialize(dispatcher, message_factory)
          @_message_factory = message_factory
          @_message_dispatcher = dispatcher
          @_relay_pool = RelayPool.new(dispatcher)
        end

        def send_message(node, encrypted_message)
          payload = payload_for(node.uid, encrypted_message)
          _relay_pool.send_payload(payload)
        end

        # @param [String] to - the uid of the person we are sending to
        # @param [String] message - the encrypted message
        def payload_for(to, encrypted_message)
          { to: to, message: encrypted_message }
        end
      end
    end
  end
end
