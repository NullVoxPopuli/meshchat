# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class Ping < Base
        def display
          # we'll never display our own ping to someone else...
          # or shouldn't.... or there should be different output
          # TODO: display is a bad method name
          name = payload['sender']['alias']
          location = payload['sender']['location']

          "#{name}@#{location} pinged you."
        end

        def handle
          respond
          display
        end

        def respond
          reply = _message_factory.create(PING_REPLY)
          _message_dispatcher.send_message(
            uid: payload['sender']['uid'],
            message: reply
          )
        end
      end
    end
  end
end
