module MeshChat
  class Command
    class SendDisconnect < Command::Base
      def self.description
        'sends a disconnect message to all users'
      end

      def handle
        Node.all.each do |n|
          _message_dispatcher.send_message(node: n, message: Message::Disconnect.new)
        end
      end
    end
  end
end
