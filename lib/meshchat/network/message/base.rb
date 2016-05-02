# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      # NOTE:
      #  #display: shows the message
      #            should be used locally, before *sending* a message
      #  #handle: processing logic for the message
      #           should be used when receiving a message, and there
      #           needs to be a response right away
      #  #respond: where the actual logic for the response goes
      class Base
        attr_accessor :payload,
          :_message, :_sender_name, :_sender_location, :_sender_uid,
          :_time_received,
          :_message_dispatcher, :_message_factory

        # @param [String] message
        # @param [Hash] sender
        # @param [Hash] payload all paramaters for a received message
        # @param [MeshChat::Network::Dispatcher] message_dispatcher optionally overrides the default payload
        # @param [MeshChat::Message::Factory] message_factory the message factory
        def initialize(
          message:            '',
          sender:             {},
          payload:            {},
          message_dispatcher: nil,
          message_factory:    nil)

          if payload.present?
            @payload = payload.deep_stringify_keys
          else
            @_message         = message
            @_sender_name     = sender['alias']
            @_sender_location = sender['location']
            @_sender_uid      = sender['uid']
            @_time_received   = Time.now.iso8601
          end

          @_message_dispatcher = message_dispatcher
          @_message_factory    = message_factory
        end

        def payload
          @payload ||= {
            'type'           => type,
            'message'        => _message,
            'client'         => client,
            'client_version' => client_version,
            'time_sent'      => _time_received,
            'sender'         => {
              'alias'        => _sender_name,
              'location'     => _sender_location,
              'uid'          => _sender_uid
            }
          }
        end

        def type
          @type ||= Factory::TYPES.invert[self.class]
        end

        def message
          _message || payload['message']
        end

        def sender
          payload['sender']
        end

        def sender_name
          _sender_name || sender['alias']
        end

        def sender_location
          _sender_location || sender['location']
        end

        def sender_uid
          _sender_uid || sender['uid']
        end

        def time_received
          _time_received || payload['time_sent']
        end

        def time_received_as_date
          DateTime.parse(time_received) if time_received
        end

        def client
          APP_CONFIG[:client_name]
        end

        def client_version
          APP_CONFIG[:client_version]
        end

        # shows the message
        # should be used locally, before *sending* a message
        def display
          {
            time:    time_received_as_date,
            from:    sender_name,
            message: message
          }
        end

        # processing logic for the message
        # should be used when receiving a message, and there
        # needs to be a response right away.
        # this may call display, if the response is always to be displayed
        def handle
          display
        end

        # Most message types aren't going to need to have an
        # immediate response.
        def respond
        end

        # this message should be called immediately
        # before sending to the whomever
        def render
          payload.to_json
        end

        alias_method :jsonized_payload, :render

        def encrypt_for(node)
          result     = jsonized_payload
          public_key = node.public_key
          result     = Encryption.encrypt(result, public_key) if node.public_key
          Base64.strict_encode64(result)
        end
      end
    end
  end
end
