# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Exit < Command::Base
        def self.description
          'exits the program'
        end

        def handle
          _input_factory._cli.shutdown
        end
      end
    end
  end
end
