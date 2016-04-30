module MeshChat
  module Net
    module Listener
      class Request
        attr_accessor :json, :message
        attr_accessor :_input
        attr_accessor :_message_dispatcher

        def initialize(encoded_message, message_dispatcher)
          self._message_dispatcher = message_dispatcher
          self._input = try_decrypt(encoded_message)

          begin
            self.json = JSON.parse(_input)
          rescue => e
            Display.debug e.message
            Display.debug e.backtrace.join("\n")
            raise Errors::BadRequest.new
          end
          self.message = process_json
        end

        private

        def try_decrypt(input)
          begin
            decoded = Base64.decode64(input)
            input = Cipher.decrypt(decoded, Settings[:privatekey])
          rescue => e
            Display.debug e.message
            Display.debug e.backtrace.join("\n")
            Display.debug input
            raise Errors::NotAuthorized.new(e.message)
          end

          input
        end

        def process_json
          type = json['type']
          klass = Message::TYPES[type]

          raise Errors::BadRequest.new(type) unless klass

          klass.new(payload: json, message_dispatcher: _message_dispatcher)
        end
      end
    end
  end
end
