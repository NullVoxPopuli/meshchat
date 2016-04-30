module MeshChat
  class Command
    class Online < Command::Base
      def self.description
        'shows online users'
      end

      def handle
        msg = Node.online.map(&:as_info).join(", ").presence || 'no one is online'

        Display.info msg
      end
    end
  end
end
