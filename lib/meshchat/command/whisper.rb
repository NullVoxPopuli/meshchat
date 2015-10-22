module MeshChat
  class Command
    class Whisper < Command::Base
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
          m = Message::Whisper.new(
            message: message,
            to: target
          )

          Display.whisper m.display

          Net::Client.send(
            node: node,
            message: m
          )
        else
          Display.alert "node for #{target} not found or is not online"
        end
      end
    end
  end
end
