require 'em-http-request'

module MeshChat
  module Net
    class MessageDispatcher
      module HttpClient
        module_function

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
          http.callback { }
        end

        def payload_for(encrypted_message)
          { message: encrypted_message }.to_json
        end
      end
    end
  end
end
