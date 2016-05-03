# frozen_string_literal: true
module Meshchat
  module Network
    extend ActiveSupport::Autoload
    NETWORK_LOCAL = :local
    NETWORK_RELAY = :relay

    eager_autoload do
      autoload :Errors
      autoload :Message
      autoload :Dispatcher
      autoload :Incoming
      autoload :Local
      autoload :Remote
      autoload :MessageProcessor
      autoload :RequestProcessor
    end
  end
end
