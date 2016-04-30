# frozen_string_literal: true
module Meshchat
  module Encryption
    # This should normally be for testing
    #
    # It just retuns the message that is asked to be encrypted
    module Passthrough
      module_function

      def encrypt(msg, *_args)
        msg
      end

      def decrypt(msg, *_args)
        msg
      end
    end
  end
end
