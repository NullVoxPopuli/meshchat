# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class SendDisconnect < Command::Base
        def self.description
          'sends a disconnect message to all users'
        end

        def handle
          message = _message_factory.create(Network::Message::DISCONNECT)

          Node.all.each do |n|
            _message_dispatcher.send_message(node: n, message: message)
          end
        end
      end
    end
  end
end
