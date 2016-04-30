# frozen_string_literal: true
module Meshchat
  module Ui
    # A user interface is responsible for for creating a client
    # and sending messages to that client
    class CLI
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :Input
        autoload :Base
        autoload :KeyboardLineInput
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

      attr_reader :_message_dispatcher, :_message_factory, :_command_factory

      def initialize(dispatcher, message_factory, _display)
        @_message_dispatcher = dispatcher
        @_message_factory = message_factory
        @_command_factory = Command::Factory.new(dispatcher, message_factory)

        # In case we need static access
        # TODO: find a way to remove
        self.class.instance_variable_set('@instance', self)
      end

      def create_input(msg)
        Display.debug("input: #{msg}")
        handler = _command_factory.create(msg)
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
        Display.alert "\n\nGoodbye.  \n\nThank you for using #{Meshchat.name}"
        exit
      end

      def send_disconnect
        fake_input = Command::Factory::Command + BASE::SEND_DISCONNECT
        command = _command_factory.create(fake_input)
        command.handle
      end
    end
  end
end
