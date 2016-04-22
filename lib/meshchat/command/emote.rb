module MeshChat
  class Command
    class Emote < Command::Chat
      def self.description
        'send an emote to the current chat'
      end

      def initialize(input, message_dispatcher)
        super
        input = input.chomp
        emote_message = input.gsub(/\A\/me /, '').chomp
        self._input = emote_message
      end

      def show_myself(message)
        Display.info message.display
      end

    end
  end
end
