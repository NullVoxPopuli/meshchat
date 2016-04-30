# frozen_string_literal: true
module Meshchat
  module Ui
    class CLI
      # this class, and all subclasses are Keyboard Handlers
      # that are used for EventMachine's open_keyboard
      # @see https://github.com/eventmachine/eventmachine/wiki/Code-Snippets#keyboard-input-example
      class Base < EventMachine::Connection
        # The class used for interpeting the line input
        attr_reader :_input_receiver
        # An array of typed keystrokes
        attr_reader :_input_buffer

        def initialize(input_receiver)
          @_input_receiver = input_receiver
          @_input_buffer = []
        end

        # override this method to alter how input is
        # interpreted by the receiver.
        #
        # hopefully, just by calling a different method
        # on the receiver, as input processing shouldn't
        # occurr in this class or any subclass unless it is
        # raw keystroke input
        #
        # @note that this method receives raw keystrokes by default
        #        and does not send data to the input receiver
        def receive_data(data)
          _input_buffer.push(data)
        end

        def receive_line(line)
          # only used when including EM::Protocols::LineText2
        end
      end
    end
  end
end
