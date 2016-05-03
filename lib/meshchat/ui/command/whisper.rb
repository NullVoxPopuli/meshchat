# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Whisper < Command::Base
        def self.description
          'sends a private message to a spepcific person'
        end

        def target
          # get first arg
          command
        end

        def message
          command_args[1..command_args.length].try(:join, ' ')
        end

        def handle
          node = Node.find_by_alias_name(target)

          if node
            m = _message_factory.create(
              Network::Message::WHISPER,
              data: {
                message: message,
                to: target
              })

            Display.whisper m.display

            _message_dispatcher.send_message(node: node, message: m)
          else
            Display.alert "node for #{target} not found or is not online"
          end
        end
      end
    end
  end
end
