# frozen_string_literal: true
module Meshchat
  module Network
    module Local
      module Listener
        extend ActiveSupport::Autoload
        eager_autoload do
          autoload :Errors
          autoload :Server
        end
      end
    end
  end
end
