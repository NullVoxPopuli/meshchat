# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class Emote < Chat
        def format_display(time, name, message)
          "#{time} #{name} #{message}"
        end
      end
    end
  end
end
