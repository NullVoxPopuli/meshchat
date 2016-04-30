# frozen_string_literal: true
module Meshchat
  module Ui
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :CLI
      autoload :Command
      autoload :Display
      autoload :Notifier
    end
  end
end
