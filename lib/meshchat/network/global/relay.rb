require 'action_cable_client'

module Meshchat
  module Network
    module Global
      class Relay
        # This channel is determine by the server, see
        # https://github.com/NullVoxPopuli/mesh-relay/blob/master/app/channels/mesh_relay_channel.rb
        CHANNEL = 'MeshRelayChannel'

        attr_reader :_url, :_client, :_request_processor
        delegate :perform, :to => :_client

        def initialize(url, message_dispatcher)
          @_url = url
          @_request_processor = Decryption::RequestProcessor.new(
            network: NETWORK_RELAY,
            location: url,
            message_dispatcher: message_dispatcher)

          setup
        end

        def setup
          path = "#{_url}?uid=#{APP_CONFIG.user['uid']}"
          @_client = ActionCableClient.new(path, CHANNEL)

          # don't output anything upon connecting
          _client.connected {}

          # If there are errors, report them!
          _client.errored do |message|
            process_error(message)
          end

          # forward the encrypted messages to our RequestProcessor
          # so that they can be decrypted
          _client.received do |message|
            process_message(message, url)
          end

          _client
        end

        # example messages:
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"message"=>"hi"}}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"error"=>"hi"}}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "type"=>"confirm_subscription"}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"error"=>"Member with UID user2 could not be found"}}
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
          _request_processor.process(message)
        rescue => e
          ap e.message
          puts e.backtrace
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
