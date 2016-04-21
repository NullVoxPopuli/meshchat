module MeshChat
  module Net
    module Listener
      module RequestProcessor
        module_function

        def process(http_content)
          encoded_message = parse_content(http_content)
          MessageProcessor.process(encoded_message)
        end

        def parse_content(http_content)
          json_body = JSON.parse(http_content)
          json_body['message']
        end
      end
    end
  end
end
