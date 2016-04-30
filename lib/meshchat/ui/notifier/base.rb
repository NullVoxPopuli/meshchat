# frozen_string_literal: true
module Meshchat
  module Ui
    module Notifier
      # This is the default notification implementation
      # - Uses Libnotify
      #
      #
      # Only use one notification and update continuously, so that
      # the notification area / tray doesn't become flooded by this app
      #
      # To write your own notifier, just override the show method in a
      # subclass of this class
      class Base
        # Notifier::Base is a singleton
        # Not all Notifiers need to be singletons,
        # but it doesn't really make sense to have more than one.
        # An OS generally only has one notification system
        class << self
          delegate :show, to: :instance

          def instance
            @instance ||= new
          end
        end

        def show(*args)
          # by default don't notify
        end
      end
    end
  end
end
