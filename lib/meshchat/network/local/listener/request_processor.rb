module MeshChat
  module Net
    module Listener
      module RequestProcessor
        module_function

        # @param [String] http_content - the encrypted message as a json string
        # @param [String] received_from - optional URL to override the sender ip
        # @param [Boolean] web_socket - signifies that the message came from a web socket
        def process(http_content, received_from = nil, web_socket = false, message_dispatcher = nil)
          encoded_message = parse_content(http_content)
          MessageProcessor.process(
            encoded_message,
            received_from: received_from,
            web_socket: web_socket,
            message_dispatcher: message_dispatcher)
        end

        def parse_content(content)
          content = JSON.parse(content) if content.is_a?(String)
          content['message']
        end
      end
    end
  end
end
