# frozen_string_literal: true
module Meshchat
  module Network
    extend ActiveSupport::Autoload
    NETWORK_LOCAL = :local
    NETWORK_RELAY = :relay

    eager_autoload do
      autoload :Message
      autoload :Dispatcher
      autoload :Decryption
      autoload :Local
      autoload :Global
      autoload :MessageProcessor
      autoload :RequestProcessor
    end
  end
end
