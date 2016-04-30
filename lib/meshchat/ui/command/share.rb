module MeshChat
  class Command
    class Share < Command::Base
      def self.description
        'exports your identity to a json file to give to another user'
      end

      def handle
        Settings.share
      end
    end
  end
end
