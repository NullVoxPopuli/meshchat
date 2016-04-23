require 'meshchat/net/listener/errors'
require 'em-http-server'

module MeshChat
  module Net
    module Listener
      class Server < EM::HttpServer::Server

        attr_accessor :message_dispatcher

        OK = 200
        BAD_REQUEST = 400
        NOT_AUTHORIZED = 401
        FORBIDDEN = 403
        SERVER_ERROR = 500

        def initialize(message_dispatcher)
          self.message_dispatcher = message_dispatcher
        end

        def process_http_request
          # the http request details are available via the following instance variables:
          # puts  @http_request_method
          # puts  @http_request_uri
          # puts  @http_query_string
          # puts  @http_protocol
          # puts  @http_content
          # puts  @http[:cookie]
          # puts  @http[:content_type]
          # # you have all the http headers in this hash
          # puts  @http.inspect
          process(@http_content)
          build_response
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
          rescue => e
            Display.error e.message
            Display.error e.backtrace.join("\n")
            build_response SERVER_ERROR, e.message
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
