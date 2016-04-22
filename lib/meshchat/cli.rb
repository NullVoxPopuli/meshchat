require 'meshchat/cli/input'
require 'meshchat/cli/base'
require 'meshchat/cli/keyboard_line_input'
require 'meshchat/command/base'
require 'meshchat/command/chat'
require 'meshchat/command/identity'
require 'meshchat/command/irb'
require 'meshchat/command/config'
require 'meshchat/command/ping'
require 'meshchat/command/ping_all'
require 'meshchat/command/server'
require 'meshchat/command/whisper'
require 'meshchat/command/exit'
require 'meshchat/command/send_disconnect'
require 'meshchat/command/help'
require 'meshchat/command/bind'
require 'meshchat/command/online'
require 'meshchat/command/offline'
require 'meshchat/command/share'
require 'meshchat/command/import'
require 'meshchat/command/emote'


module MeshChat
  # A user interface is responsible for for creating a client
  # and sending messages to that client
  class CLI
    COMMAND_MAP = {
      MeshChat::Command::Base::CONFIG => MeshChat::Command::Config,
      MeshChat::Command::Base::PING => MeshChat::Command::Ping,
      MeshChat::Command::Base::PING_ALL => MeshChat::Command::PingAll,
      MeshChat::Command::Base::SERVERS => MeshChat::Command::Server,
      MeshChat::Command::Base::SERVER => MeshChat::Command::Server,
      MeshChat::Command::Base::EXIT => MeshChat::Command::Exit,
      MeshChat::Command::Base::QUIT => MeshChat::Command::Exit,
      MeshChat::Command::Base::IDENTITY => MeshChat::Command::Identity,
      MeshChat::Command::Base::IRB => MeshChat::Command::IRB,
      MeshChat::Command::Base::SHARE => MeshChat::Command::Share,
      MeshChat::Command::Base::IMPORT => MeshChat::Command::Import,
      MeshChat::Command::Base::EXPORT => MeshChat::Command::Share,
      MeshChat::Command::Base::ONLINE => MeshChat::Command::Online,
      MeshChat::Command::Base::OFFLINE => MeshChat::Command::Offline,
      MeshChat::Command::Base::HELP => MeshChat::Command::Help,
      MeshChat::Command::Base::BIND => MeshChat::Command::Bind,
      MeshChat::Command::Base::SEND_DISCONNECT => MeshChat::Command::SendDisconnect,
      MeshChat::Command::Base::EMOTE => MeshChat::Command::Emote,
      MeshChat::Command::Base::CHAT => MeshChat::Command::Chat

    }

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
