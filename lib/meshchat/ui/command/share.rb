# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Share < Command::Base
        def self.description
          'exports your identity to a json file to give to another user'
        end

        def handle
          APP_CONFIG.user.share
        end
      end
    end
  end
end
