# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Offline < Command::Base
        def self.description
          'shows offline users'
        end

        def handle
          list = Node.offline.map(&:as_info)
          msg = if list.present?
                  list.join(', ')
                else
                  'no one is offline'
                end

          Display.info msg
        end
      end
    end
  end
end
