# frozen_string_literal: true
module Meshchat
  module Ui
    # A user interface is responsible for for creating a client
    # and sending messages to that client
    class CLI
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :InputFactory
        autoload :Base
        autoload :KeyboardLineInput
      end

      attr_reader :_message_dispatcher, :_message_factory, :_command_factory

      def initialize(dispatcher, message_factory, _display)
        @_message_dispatcher = dispatcher
        @_message_factory = message_factory
        @_command_factory = InputFactory.new(dispatcher, message_factory, self)
      end

      def create_input(msg)
        handler = _command_factory.create(for_input: msg)
        handler.handle
      rescue => e
        Debug.creating_input_failed(e)
      end

      # save config and exit
      def shutdown
        # close_server
        Display.info 'saving config...'
        APP_CONFIG.user.save
        Display.info 'notifying of disconnection...'
        send_disconnect
        Display.alert "\n\nGoodbye.  \n\nThank you for using #{Meshchat.name}"
        exit
      end

      def send_disconnect
        klass   = Command::SendDisconnect
        command = _command_factory.create(with_class: klass)
        command.handle
      end
    end
  end
end
