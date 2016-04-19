require 'meshchat/net/listener/errors'
require 'em-http-server'

module MeshChat
  module Net
    module Listener
      class Server < EM::Connection
        include EM::HttpServer

        OK = 200
        BAD_REQUEST = 400
        NOT_AUTHORIZED = 401
        FORBIDDEN = 403
        SERVER_ERROR = 500

        def process_http_request
          # the http request details are available via the following instance variables:
          #   @http_protocol
          #   @http_request_method
          #   @http_cookie
          #   @http_if_none_match
          #   @http_content_type
          #   @http_path_info
          #   @http_request_uri
          #   @http_query_string
          #   @http_post_content
          #   @http_headers
          process_request
          build_response
        end


        def process_request
          begin
            # form params should override
            # raw body
            raw = get_message
            process(raw)
          rescue => e
            Display.error e.message
            Display.error e.backtrace.join("\n")
            build_response SERVER_ERROR, e.message
          end
        end

        def get_message
          # if received as form data
          return @http_post_content[:message] if @http_post_content[:message]

          # if received as json
          request_body = @http_post_content # request.body.read
          json_body = JSON.parse(request_body)
          json_body['message']
        end

        def process(raw)
          # decode, etc
          begin
            RequestProcessor.process(raw)
          rescue Errors::NotAuthorized
            build_response NOT_AUTHORIZED
          rescue Errors::Forbidden
            build_response FORBIDDEN
          rescue Errors::BadRequest
            build_response BAD_REQUEST
          end
        end

        def build_response(s = OK, message = '')
          response = EM::DelegatedHttpResponse.new(self)
          response.status = s
          response.content_type 'text/json'
          response.content = message
          response.send_response
        end
      end
    end
  end
end
