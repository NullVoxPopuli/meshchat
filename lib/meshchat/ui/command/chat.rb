# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Chat < Command::Base
        def handle
          servers = Node.online
          if !servers.empty?
            type = self.class.name.demodulize.downcase
            m = _message_factory.create(type, data: { message: _input })
            show_myself(m)

            # if sending to all, iterate thorugh list of
            # servers, and send to each one
            # TODO: do this async so that one server doesn't block
            # the rest of the servers from receiving the messages
            servers.each do |entry|
              _message_dispatcher.send_message(node: entry, message: m)
            end
          else
            Display.warning 'you have no servers'
          end
        end

        def show_myself(message)
          Display.chat message.display
        end
      end
    end
  end
end
