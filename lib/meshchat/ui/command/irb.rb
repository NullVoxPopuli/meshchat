# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      # TODO: remove this command before release
      class Irb < Command::Base
        def self.description
          'runs ruby commands (useful for debugging)'
        end

        def handle
          code = command_args[1..command_args.length].join(' ')
          ap eval(code)
          ''
        rescue => e
          ap e.message
          ap e.backtrace
        end
      end
    end
  end
end
