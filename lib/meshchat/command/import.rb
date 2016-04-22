module MeshChat
  class Command
    class Import < Command::Base
      def self.description
        'imports an identity file (formatted as json)'
      end

      def handle
        if command_valid?
          node = Models::Entry.import_from_file(filename)
          if node.valid? && node.persisted?
            Display.success "#{node.alias_name} successfully imported"

            # send the server list to this new node
            _message_dispatcher.send_message(
              node: node,
              message: Message::NodeList.new
            )
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
