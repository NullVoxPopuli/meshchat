# frozen_string_literal: true
module Meshchat
  module Network
    module Incoming
      class MessageDecryptor
        attr_reader :_json, :_message, :_input
        attr_reader :_message_factory

        def initialize(encoded_message, message_factory)
          @_message_factory = message_factory
          @_input = try_decrypt(encoded_message)
          @_json = parse_json(@_input)
          @_message = process_json
        end

        def message
          _message
        end

        private

        def parse_json(input)
          return JSON.parse(input)
        rescue => e
          Display.debug e.message
          Display.debug e.backtrace.join("\n")
          raise Errors::BadRequest, 'could not parse json'
        end

        def try_decrypt(input)
          begin
            decoded = Base64.decode64(input)
            input = Encryption.decrypt(decoded, APP_CONFIG.user[:privatekey])
          rescue => e
            Display.debug e.message
            Display.debug e.backtrace.join("\n")
            Display.debug input
            raise Errors::NotAuthorized, e.message
          end

          input
        end

        def process_json
          type = _json['type']
          _message_factory.create(type, data: { payload: _json })
        end
      end
    end
  end
end
