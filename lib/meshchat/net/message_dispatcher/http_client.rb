module MeshChat
  module Net
    class MessageDispatcher
      module HttpClient
        module_function

        # @param [String] location - the address of the person to send to
        # @param [JSON] encrypted_message - the message intended for the person at the location
        def send_message(location, encrypted_message)
          payload = payload_for(encrypted_message)
          # TODO: use evented sending
          Curl::Easy.http_post(location, payload) do |c|
            c.headers['Accept'] = 'application/json'
            c.headers['Content-Type'] = 'application/json'
          end
        end

        def payload_for(encrypted_message)
          { message: encrypted_message}.to_json
        end
      end
    end
  end
end
