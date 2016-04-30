module MeshChat
  class Command
    class Server < Command::Base
      ONLINE = 'online'
      def self.description
        'known server statuses'
      end


      def handle
        case sub_command
        when ONLINE
          Display.info Node.online.map(&:as_info).join(', ') || 'no one is online'
        else
          Display.info Node.all.map(&:as_info).join(', ') || 'there are no nodes'
        end
      end
    end
  end
end
