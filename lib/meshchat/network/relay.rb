# frozen_string_literal: true
module Meshchat
  module Network
    module Relay
      extend ActiveSupport::Autoload
      eager_autoload do
        autoload :Connection
        autoload :RelayPool
      end
    end
  end
end
