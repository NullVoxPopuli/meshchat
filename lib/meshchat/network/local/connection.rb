# frozen_string_literal: true
require 'em-http-request'

module Meshchat
  module Network
    module Local
      class Connection
        attr_reader :_message_factory, :_message_dispatcher

        def initialize(dispatcher, message_factory)
          @_message_factory = message_factory
          @_message_dispatcher = dispatcher

          # async, won't prevent us from sending
          start_server
        end

        def start_server
          port = APP_CONFIG.user['port']
          Display.info "listening on port #{port}"
          EM.start_server('0.0.0.0', port,
            Network::Local::Server, _message_dispatcher)
        end

        # @param [Node] node - the node describing the person you're sending a message to
        # @param [JSON] encrypted_message - the message intended for the person at the location
        # @param [Block] error_callback - what to do in case of failure
        def send_message(node, encrypted_message, &error_callback)
          payload = payload_for(encrypted_message)
          create_http_request(node.location_on_network, payload, &error_callback)
        end

        def create_http_request(location, payload, &error_callback)
          # TODO: what about https?
          #       maybe do the regex match: /https?:\/\//
          location = 'http://' + location unless location.include?('http://')
          http = EventMachine::HttpRequest.new(location).post(
            body: payload,
            head: {
              'Accept' => 'application/json',
              'Content-Type' => 'application/json'
            })

          http.errback &error_callback
          # example things available in the callback
          # p http.response_header.status
          # p http.response_header
          # p http.response
          http.callback {}
        end

        def payload_for(encrypted_message)
          { message: encrypted_message }.to_json
        end
      end
    end
  end
end
