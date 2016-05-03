# frozen_string_literal: true
module Meshchat
  module Network
    module Remote
      extend ActiveSupport::Autoload
      eager_autoload do
        autoload :Connection
        autoload :RelayPool
        autoload :Relay
      end
    end
  end
end
