module MeshChat
  module Display
    class Base

      # instantiate the UI, startup the CLI
      def start
        fail 'overload this method'
      end

      # output a generic line of text
      def add_line(_line)
        fail 'overload this method'
      end

      # formatter for a whisper message
      def whisper(_line)
        fail 'overload this method'
      end


      # an emote
      def emote(_line)
        fail 'overload this method'
      end


      # server info or other ignorable information
      def info(_line)
        fail 'overload this method'
      end

      # warning message that the user may or may not care about
      def warning(_line)
        fail 'overload this method'
      end

      # really try to get the user's attention
      def alert(_line)
        fail 'overload this method'
      end

      # a happy message to affirm the user something succeded
      def success(_line)
        fail 'overload this method'
      end

      # general chat message
      def chat(_line)
        fail 'overload this method'
      end



      # log a message
      def log(_msg)
        fail 'overload this method'
      end
    end
  end
end
