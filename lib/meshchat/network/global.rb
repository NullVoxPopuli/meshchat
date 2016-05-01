# frozen_string_literal: true
module Meshchat
  module Network
    module Global
      extend ActiveSupport::Autoload
      eager_autoload do
        autoload :Connection
        autoload :RelayPool
        autoload :Relay
      end
    end
  end
end
