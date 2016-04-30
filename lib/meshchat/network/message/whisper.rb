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

          @_to = to
        end
      end
    end
  end
end
