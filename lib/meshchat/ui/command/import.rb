# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Import < Command::Base
        def self.description
          'imports an identity file (formatted as json)'
        end

        def handle
          if command_valid?
            node = Node.import_from_file(filename)
            if node.valid? && node.persisted?
              Display.success "#{node.alias_name} successfully imported"

              # send the server list to this new node
              node_list = _message_factory.create(Network::Message::NODE_LIST)
              _message_dispatcher.send_message(node: node, message: node_list)
            else
              Display.alert "#{node.alias_name} is invalid"
              Display.alert node.errors.full_messages.join("\n")
            end
          else
            Display.alert usage
          end
        end

        def usage
          'Usage: /import {filename}'
        end

        def command_valid?
          filename.present?
        end

        def filename
          sub_command
        end
      end
    end
  end
end
