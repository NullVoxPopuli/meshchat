module MeshChat
  class Command

    # TODO: remove this command before release
    class IRB < Command::Base
      def self.description
        'runs ruby commands (useful for debugging)'
      end

      def handle
        begin
          code = command_args[1..command_args.length].join(' ')
          ap eval(code)
          ''
        rescue => e
          ap e.message
          ap e.backtrace
        end
      end
    end
  end
end
