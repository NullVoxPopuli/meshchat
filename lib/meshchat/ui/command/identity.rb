# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Identity < Command::Base
        def self.description
          'displays your identity'
        end

        def handle
          Display.success Settings.identity
        end
      end
    end
  end
end
