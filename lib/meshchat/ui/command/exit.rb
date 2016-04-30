# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Exit < Command::Base
        def self.description
          'exits the program'
        end

        def handle
          CLI.shutdown
        end
      end
    end
  end
end
