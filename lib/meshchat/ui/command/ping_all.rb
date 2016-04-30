# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class PingAll < Command::Base
        def self.description
          'pings all known users'
        end

        def handle
          ping = _message_factory.create(Network::Message::PING)
          Node.all.each do |n|
            _message_dispatcher.send_message(node: n, message: ping)
          end
        end
      end
    end
  end
end
