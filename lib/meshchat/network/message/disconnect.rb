# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class Disconnect < Base
        def display
          location = payload['sender']['location']
          uid = payload['sender']['uid']
          name = payload['sender']['alias']
          node = Node.find_by_uid(uid)
          if node
            node.update(on_local_network: false)
            node.update(on_relay: false)
          end

          "#{name}@#{location} has disconnected"
        end
      end
    end
  end
end
