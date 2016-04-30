module MeshChat
  class Command
    class Help < Command::Base
      def self.description
        'displays this help message'
      end

      def handle
        MeshChat::CLI::COMMAND_MAP.each do |key, klass|
          if klass.respond_to?(:description)
            Display.info "/#{key}\t\t" + klass.description
          end
        end
      end
    end
  end
end
