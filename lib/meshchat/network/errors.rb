# frozen_string_literal: true
module Meshchat
  module Network
    module Errors
      class NotAuthorized < StandardError; end
      class Forbidden < StandardError; end
      class BadRequest < StandardError; end
      class MessageTypeNotRecognized < StandardError; end
    end
  end
end
