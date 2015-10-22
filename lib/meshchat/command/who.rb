module MeshChat
  class Command
    class Who < Command::Base
      def handle
        Display.info Node.online.map(&:as_info) || 'no one is online'
      end
    end
  end
end
