require 'action_cable_client'

module MeshChat
  module Net
    class MessageDispatcher
      class Relay
        # This channel is set by the server
        CHANNEL = 'MeshRelayChannel'
        # TODO: add a way to configure relay nodes
        RELAYS = [
          "ws://mesh-relay-in-us-1.herokuapp.com"
          # "ws://localhost:3000"
        ]

        attr_accessor :_active_relay, :_message_dispatcher
        attr_accessor :_active_relay_url

        def initialize(message_dispatcher)
          @_message_dispatcher = message_dispatcher
        end

        # TODO: add logic for just selecting the first available relay.
        #       we only need one connection.
        # @return [Array] an array of action cable clients
        def setup
          url = RELAYS.first
          @_active_relay = setup_client_for_url(url)
          @_active_relay_url = url
        end

        # @param [Node] node - the node describing the person you're sending a message to
        # @param [JSON] encrypted_message - the message intended for the person at the location
        def send_message(node, encrypted_message)
          return if _active_relay.blank?

          Debug.sending_message_over_relay(node, encrypted_message, _active_relay_url)

          payload = payload_for(node.uid, encrypted_message)
          # Use first relay for now
          # TODO: figure out logic for which relay to send to
          # might have to do with mesh logic
          _active_relay.perform('chat', payload)
        end

        # @param [String] to - the uid of the person we are sending to
        # @param [String] message - the encrypted message
        def payload_for(to, encrypted_message)
          { to: to, message: encrypted_message }
        end

        def setup_client_for_url(url)
          path = "#{url}?uid=#{Settings['uid']}"
          client = ActionCableClient.new(path, CHANNEL)

          # don't output anything upon connecting
          client.connected { }

          # If there are errors, report them!
          client.errored do |message|
            process_error(message)
          end

          # forward the encrypted messages to our RequestProcessor
          # so that they can be decrypted
          client.received do |message|
            process_message(message, url)
          end

          client
        end

        # example messages:
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"message"=>"hi"}}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"error"=>"hi"}}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "type"=>"confirm_subscription"}
        def process_message(message, received_from)
          Debug.received_message_from_relay(message, received_from)

          identifier, type, message = message.values_at('identifier', 'type', 'message')

          # do we want to do anything here?
          return if type == 'confirm_subscription'
          # are there any other types of websocket messages?
          return unless message

          if message['message']
            chat_message_received(message, received_from)
          elsif error = message['error']
            error_message_received(error)
          end
        end

        # TODO: what does an error message look like?
        # TODO: what are situations in which we receive an error message?
        def process_error(message)
          Display.alert(message)
        end

        def chat_message_received(message, received_from)
          begin
            Net::Listener::RequestProcessor.process(
              message,
              received_from,
                true, _message_dispatcher)
          rescue => e
            ap e.message
            puts e.backtrace
          end
        end

        def error_message_received(message)
          Display.alert message
          # TODO: find the intended node.
          #       if on_local_network is true, send to http_client

          # Display.info "#{node.alias_name} has ventured offline"
          # Debug.person_not_online(node, message, e)
        end
      end

    end
  end
end
