# frozen_string_literal: true
module Meshchat
  module Network
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :Message
      autoload :Dispatcher
      autoload :Relay
      autoload :Local
    end
  end
end
