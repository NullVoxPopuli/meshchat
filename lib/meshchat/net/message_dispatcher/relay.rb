require 'action_cable_client'

module MeshChat
  module Net
    class MessageDispatcher
      class Relay
        # This channel is set by the server
        CHANNEL = 'MeshRelayChannel'
        # TODO: add a way to configure relay nodes
        RELAYS = [
          # "ws://mesh-relay-in-us-1.herokuapp.com"
          "ws://localhost:3000"
        ]

        def initialize

        end

        # @return [Array] an array of action cable clients
        def setup
          @relays ||= RELAYS.map do |url|
            setup_client_for_url(url)
          end
        end

        # @param [Node] node - the node describing the person you're sending a message to
        # @param [JSON] encrypted_message - the message intended for the person at the location
        def send_message(node, encrypted_message)
          return if @relays.empty?

          Debug.sending_message_over_relay(node, '@relays.first._url')

          payload = payload_for(node.uid, encrypted_message)
          # Use first relay for now
          # TODO: figure out logic for which relay to send to
          # might have to do with mesh logic
          @relays.first.perform('chat', payload)
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

        def process_message(message, received_from)
          Debug.received_message_from_relay(message, received_from)

          identifier = message['identifier']
          type = message['type']
          message = message['message']

          if type == 'confirm_subscription'
            # do we want to do anything here?
          end

          if message
            # TODO: uddate the node's location?
            Net::Listener::RequestProcessor.process(message, received_from)
          end
        end

        # TODO: what does an error message look like?
        # TODO: what are situations in which we receive an error message?
        def process_error(message)
          ap 'socket error'
          ap message

          # TODO: find the intended node.
          #       if on_local_network is true, send to http_client

          Display.alert(message)
          # Display.info "#{node.alias_name} has ventured offline"
          # Debug.person_not_online(node, message, e)
        end
      end
    end
  end
end
