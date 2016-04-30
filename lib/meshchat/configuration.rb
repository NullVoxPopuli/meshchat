# frozen_string_literal: true
module Meshchat
  module Configuration
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Database
      autoload :HashFile
      autoload :Settings
      autoload :Identity
      autoload :AppConfig
    end
  end
end
