# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Base
        # Commands
        SET = 'set'
        CONFIG = 'config'
        DISPLAY = 'display'
        EXIT = 'exit'
        QUIT = 'quit'
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

        attr_reader :_input, :_message_dispatcher
        attr_reader :_message_factory, :_input_factory

        def initialize(input, message_dispatcher, message_factory, input_factory)
          @_input              = input&.chomp
          @_message_dispatcher = message_dispatcher
          @_message_factory    = message_factory
          @_input_factory      = input_factory
        end

        def handle
          klass = COMMAND_MAP[command]
          Display.debug("INPUT: #{klass&.name} from #{command} derived from #{_input}")
          if klass
            _input_factory.create(for_input: _input, with_class: klass).handle
          else
            Display.alert 'not implemented...'
          end
        end

        protected

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
end
