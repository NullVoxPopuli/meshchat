require 'em-http-request'

module MeshChat
  module Net
    class MessageDispatcher
      module HttpClient
        module_function

        # @param [String] location - the address of the person to send to
        # @param [JSON] encrypted_message - the message intended for the person at the location
        # @param [Block] error_callback - what to do in case of failure
        def send_message(location, encrypted_message, error_callback)
          payload = payload_for(encrypted_message)
          create_http_request(location, payload, error_callback)
        end

        def create_http_request(location, payload, error_callback)
          ap location
          http = EventMachine::HttpRequest.new(location).post(
            body: payload,
            head: {
              'Accept' => 'application/json',
              'Content-Type' => 'application/json'
            })

          http.errback &error_callback
          http.callback { Debug.http_client_success_callback_data(http) }
        end

        def payload_for(encrypted_message)
          { message: encrypted_message }.to_json
        end
      end
    end
  end
end
