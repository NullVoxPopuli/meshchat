# frozen_string_literal: true
module Meshchat
  module Network
    module Relay
      class Connection

        def initialize

        end

        def send_message(_node, encrypted_message)
          payload = payload_for(encrypted_message)
        end

        def payload_for(encrypted_message)
          { message: encrypted_message }.to_json
        end
      end
    end
  end
end
