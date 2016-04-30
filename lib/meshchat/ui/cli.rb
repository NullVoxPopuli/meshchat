module MeshChat
  # A user interface is responsible for for creating a client
  # and sending messages to that client
  class CLI
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Input
      autoload :Base
      autoload :KeyboardLineInput
      autoload :Command
    end

    class << self
      delegate :server_location, :listen_for_commands,
        :shutdown, :client, :server,
        :create_input, :close_server,
        to: :instance

      def create(input_klass)
        @input_klass = input_klass
        @instance = new(input_klass)
      end

      def get_input
        instance.get_input
      end

      def instance
        # default input collector
        @instance ||= new
      end
    end

    attr_reader :_message_dispatcher

    def initialize(message_dispatcher, display)
      @_message_dispatcher = message_dispatcher
      self.class.instance_variable_set('@instance', self)
    end

    def create_input(msg)
      Display.debug("input: #{msg}")
      handler = Input.create(msg, _message_dispatcher)
      handler.handle
    rescue => e
      Debug.creating_input_failed(e)
    end

    def server_location
      Settings.location
    end

    def close_program
      exit
    end

    # save config and exit
    def shutdown
      # close_server
      Display.info 'saving config...'
      Settings.save
      Display.info 'notifying of disconnection...'
      send_disconnect
      Display.alert "\n\nGoodbye.  \n\nThank you for using #{MeshChat.name}"
      exit
    end

    def send_disconnect
      MeshChat::Command::SendDisconnect.new('/senddisconnect', _message_dispatcher)
    end
  end
end
