# frozen_string_literal: true
module Meshchat
  module Ui
    module Display
      class Base
        # instantiate the UI, startup the CLI
        def start
          raise 'overload this method'
        end

        # output a generic line of text
        def add_line(_line)
          raise 'overload this method'
        end

        # formatter for a whisper message
        def whisper(_line)
          raise 'overload this method'
        end

        # an emote
        def emote(_line)
          raise 'overload this method'
        end

        # server info or other ignorable information
        def info(_line)
          raise 'overload this method'
        end

        # warning message that the user may or may not care about
        def warning(_line)
          raise 'overload this method'
        end

        # really try to get the user's attention
        def alert(_line)
          raise 'overload this method'
        end

        # a happy message to affirm the user something succeded
        def success(_line)
          raise 'overload this method'
        end

        # general chat message
        def chat(_line)
          raise 'overload this method'
        end

        # log a message
        def log(_msg)
          raise 'overload this method'
        end
      end
    end
  end
end
