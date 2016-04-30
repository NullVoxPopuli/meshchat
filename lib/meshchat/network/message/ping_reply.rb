# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class PingReply < Base
        def display
          'ping successful' if Settings.debug?
        end
      end
    end
  end
end
