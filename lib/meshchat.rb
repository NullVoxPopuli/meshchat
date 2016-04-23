# required standard libs
require 'openssl'
require 'socket'
require 'json'
require 'date'
require 'colorize'
require 'io/console'
require "readline"
require 'logger'

# required gems
require 'awesome_print'
require 'sqlite3'
require 'active_record'
require 'eventmachine'
require 'i18n'

# active support extensions
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

# local files for meshchat
require 'meshchat/version'
# debug logging....
# ^ at least util 'all' scenarios are captured via tests
require 'meshchat/debug'
# everything else
require 'meshchat/database'
require 'meshchat/encryption'
require 'meshchat/display'
require 'meshchat/display/manager'
require 'meshchat/notifier/base'
require 'meshchat/models/entry'
require 'meshchat/config/hash_file'
require 'meshchat/config/settings'
require 'meshchat/net/request'
require 'meshchat/net/message_dispatcher/relay'
require 'meshchat/net/message_dispatcher/http_client'
require 'meshchat/net/message_dispatcher'
require 'meshchat/net/listener/request'
require 'meshchat/net/listener/message_processor'
require 'meshchat/net/listener/request_processor'
require 'meshchat/net/listener/server'
require 'meshchat/cli'
require 'meshchat/message'
require 'meshchat/identity'
require 'meshchat/configuration'

module MeshChat
  Settings = Config::Settings
  Node = Models::Entry
  Cipher = Encryption

  module_function

  # @param [Hash] overrides
  # @option overrides [Proc] on_display_start what to do upon start of the display manager
  # @option overrides [class] display the display ui to use inherited from Display::Base
  def start(overrides = {})
    app_config = Configuration.new(overrides)

    # Check user config, go through initial setup if we haven't done so already.
    # This should only need to be done once per user.
    #
    # This will also generate a whatever-alias-you-choose.json that the user
    # can pass around to someone gain access to the network.
    #
    # Personal settings are stored in settings.json. This should never be
    # shared with anyone.
    Identity.check_or_create

    # setup the storage - for keeping track of nodes on the network
    Database.setup_storage

    # if everything is configured correctly, boot the app
    # this handles all of the asyncronous stuff
    EventMachine.run do
      # 1. hook up the display / output 'device'
      #    - responsible for notifications
      #    - created in Configuration
      display = CurrentDisplay

      # 2. create the message dispatcher
      #    - sends the messages out to the network
      #    - tries p2p first, than uses the relays
      message_dispatcher = Net::MessageDispatcher.new

      # 3. boot up the http server
      #    - for listening for incoming requests
      port = Settings['port']
      server_class = MeshChat::Net::Listener::Server
      EM.start_server '0.0.0.0', port, server_class, message_dispatcher

      # 4. hook up the keyboard / input 'device'
      #    - tesponsible for parsing input
      input_receiver = CLI.new(message_dispatcher, display)
      # by default the app_config[:input] is
      # MeshChat::Cli::KeyboardLineInput
      EM.open_keyboard(app_config[:input], input_receiver)
    end
  end
end
