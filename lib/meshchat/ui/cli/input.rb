# frozen_string_literal: true
module Meshchat
  module Ui
    class CLI
      class Input
        WHISPER = '@'
        COMMAND = '/'

        attr_accessor :_message_dispatcher, :_message_factory

        def initialize(message_dispatcher, message_factory)
          self._message_dispatcher = message_dispatcher
          self._message_factory    = message_factory
        end

        def is_command?(input)
          input[0, 1] == COMMAND
        end

        def is_whisper?(input)
          input[0, 1] == WHISPER
        end

        def create(input)
          klass =
            if is_command?(input)
              Command::Base
            elsif is_whisper?(input)
              Command::Whisper
            else
              Command::Chat
            end

          Display.debug("INPUT: Detected '#{klass.name}' from '#{input}'")
          klass.new(input, message_dispatcher)
        end
      end
    end
  end
end
