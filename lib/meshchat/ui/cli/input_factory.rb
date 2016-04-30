# frozen_string_literal: true
module Meshchat
  module Ui
    class CLI
      class InputFactory
        WHISPER = '@'
        COMMAND = '/'

        attr_accessor :_message_dispatcher, :_message_factory, :_cli

        def initialize(message_dispatcher, message_factory, cli)
          self._message_dispatcher = message_dispatcher
          self._message_factory    = message_factory
          self._cli                = cli
        end

        def is_command?(input)
          input[0, 1] == COMMAND
        end

        def is_whisper?(input)
          input[0, 1] == WHISPER
        end

        def create(for_input: nil, with_class: nil)
          return create_with_class(for_input, with_class) if with_class

          create_for_input(for_input)
        end

        def create_with_class(input, klass)
          klass.new(input, _message_dispatcher, _message_factory, self)
        end

        def create_for_input(input)
          klass =
            if is_command?(input)
              Command::Base
            elsif is_whisper?(input)
              Command::Whisper
            else
              Command::Chat
            end

          create_with_class(input, klass)
        end
      end
    end
  end
end
