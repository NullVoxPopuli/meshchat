module MeshChat
  class Command
    class Base < CLI::Input
      attr_accessor :_input

      # Commands
      SET = 'set'
      CONFIG = 'config'
      DISPLAY = 'display'
      EXIT = 'exit'
      QUIT = 'quit'
      CONNECT = 'connect'
      CHAT = 'chat'
      ADD = 'add'
      REMOVE = 'remove'
      RM = 'rm'
      SERVERS = 'servers'
      SERVER = 'server'
      WHO = 'who'
      PING = 'ping'
      PING_ALL = 'pingall'
      IDENTITY = 'identity'
      IRB = 'c'
      SHARE = 'share'
      IMPORT = 'import'
      EXPORT = 'export'
      ONLINE = 'online'
      OFFLINE = 'offline'
      HELP = 'help'
      BIND = 'bind'
      SEND_DISCONNECT = 'senddisconnect'
      EMOTE = 'me'

      def handle
        klass = CLI::COMMAND_MAP[command]
        Display.debug("INPUT: #{klass&.name} from #{command} derived from #{_input}")
        if klass
          klass.new(_input).handle
        else
          Display.alert 'not implemented...'
        end
      end

      protected

      def corresponding_message_class
        my_kind = self.class.name.demodulize
        message_root_name = MeshChat::Message.name
        message_class_name = "#{message_root_name}::#{my_kind}"

        Display.debug("Corresponding: #{message_class_name}")

        message_class_name.constantize
      end

      def command_string
        @command_string ||= _input[1, _input.length]
      end

      def command_args
        @command_args ||= command_string.split(' ')
      end

      def command
        @command ||= command_args.first
      end

      def sub_command_args
        @sub_command_args ||= command_args[2..3]
      end

      def sub_command
        @sub_command ||= command_args[1]
      end
    end
  end
end
