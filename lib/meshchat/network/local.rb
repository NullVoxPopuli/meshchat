# frozen_string_literal: true
module Meshchat
  module Network
    module Local
      extend ActiveSupport::Autoload
      eager_autoload do
        autoload :Server
        autoload :Connection
      end
    end
  end
end
