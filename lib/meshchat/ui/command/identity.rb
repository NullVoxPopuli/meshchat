module MeshChat
  class Command
    class Identity < Command::Base
      def self.description
        'displays your identity'
      end

      def handle
        Display.success Settings.identity
      end
    end
  end
end
