# frozen_string_literal: true
module Meshchat
  module Ui
    class CLI
      class KeyboardLineInput < CLI::Base
        include EM::Protocols::LineText2

        def receive_line(data)
          _input_receiver.create_input(data)
        end
      end
    end
  end
end
