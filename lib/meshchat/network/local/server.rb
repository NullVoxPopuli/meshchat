# frozen_string_literal: true
require 'evma_httpserver'

module Meshchat
  module Network
    module Local
      # This is created every request
      class Server < EM::Connection
        include EM::HttpServer
        attr_reader :_message_dispatcher, :_request_processor

        OK = 200
        BAD_REQUEST = 400
        NOT_AUTHORIZED = 401
        FORBIDDEN = 403
        SERVER_ERROR = 500

        def initialize(message_dispatcher)
          @_message_dispatcher = message_dispatcher
          @_request_processor = Incoming::RequestProcessor.new(
            network: NETWORK_LOCAL,
            message_dispatcher: message_dispatcher)
        end

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
          # view what instance variables are available thorugh the
          # instance_variables method

          process(@http_post_content)
          build_response
        end

        def process(raw)
          # decode, etc
          _request_processor.process(raw)
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
