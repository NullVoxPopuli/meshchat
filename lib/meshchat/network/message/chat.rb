# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class Chat < Base
        def display
          time_recieved = self.time_recieved.strftime('%e/%m/%y %H:%I:%M')
          name = payload['sender']['alias']
          message = payload['message']

          format_display(time_recieved, name, message)
        end

        def format_display(time, name, message)
          "#{time} #{name} > #{message}"
        end
      end
    end
  end
end
