# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class Whisper < Base
        attr_accessor :_to

        def initialize(
          message:            nil,
          sender:             {},
          payload:            {},
          to:                 '',
          message_dispatcher: nil,
          message_factory:    nil)

          super(
            message:            message,
            sender:             sender,
            payload:            payload,
            message_dispatcher: message_dispatcher,
            message_factory:    message_factory)

          self._to = to
        end

        def display
          # TODO: defer to display
          time_sent     = payload['time_sent'].to_s
          time          = Date.parse(time_sent)
          time_recieved = time.strftime('%e/%m/%y %H:%I:%M')

          to = _to.present? ? "->#{_to}" : ''
          "#{time_recieved} #{sender_name}#{to} > #{message}"
        end
      end
    end
  end
end
