# frozen_string_literal: true
module Meshchat
  module Network
    module Local
      module Listener
        module Errors
          class NotAuthorized < StandardError; end
          class Forbidden < StandardError; end
          class BadRequest < StandardError; end
        end
      end
    end
  end
end
