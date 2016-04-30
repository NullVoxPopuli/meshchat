module MeshChat
  class Command
    class Exit < Command::Base
      def self.description
        'exits the program'
      end

      def handle
        CLI.shutdown
      end
    end
  end
end
