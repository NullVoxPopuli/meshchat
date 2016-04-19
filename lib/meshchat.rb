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
require 'curb'
require 'thin'
require 'action_cable_client'

# active support extensions
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

# local files for meshchat
require 'meshchat/version'
require 'meshchat/database'
require 'meshchat/instance'
require 'meshchat/encryption'
require 'meshchat/display'
require 'meshchat/display/manager'
require 'meshchat/notifier/base'
require 'meshchat/models/entry'
require 'meshchat/config/hash_file'
require 'meshchat/config/settings'
require 'meshchat/net/request'
require 'meshchat/net/client'
require 'meshchat/net/listener/request'
require 'meshchat/net/listener/request_processor'
require 'meshchat/net/listener/server'
require 'meshchat/cli'
require 'meshchat/message'
require 'meshchat/identity'

module MeshChat
  NAME = 'MeshChat'
  Settings = Config::Settings
  Node = Models::Entry
  Cipher = Encryption

  module_function

  # @param [Hash] overrides
  # @option overrides [Proc] on_display_start what to do upon start of the display manager
  # @option overrides [class] display the display ui to use inherited from Display::Base
  def start(overrides = {})
    options = configure(overrides)
    # Check user config, go through initial setup if we haven't done so already.
    # This should only need to be done once per user.
    #
    # This will also generate a whatever-alias-you-choose.json that the user
    # can pass around to someone gain access to the network.
    #
    # Personal settings are stored in settings.json. This should never be
    # shared with anyone.
    #
    # Once configured, the user will need to reboot the app with the --init
    # parameter.
    Identity.check_or_create

    # setup the storage - for keeping track of nodes on the network
    Database.setup_storage

    # if everything is configured correctly, boot the app
    # this handles all of the asyncronous stuff
    EventMachine.run do
      # 1. hook up the display / output 'device'
      #    - responsible for notifications
      display = CurrentDisplay
      # 2. boot up the http server
      #    - for listening for incoming requests
      # TODO: write EM-based http server
      # 3. boot up the action cable client
      #    - responsible for the relay server if the http client can't
      #    - find the recipient
      ac_clients = setup_action_cable_clients

      # 4. hook up the keyboard / input 'device'
      #    - tesponsible for parsing input
      # TODO: merge with existing input handler
      EM.open_keyboard(KeyboardHandler, ac_clients, display)
    end
  end

  # TODO: extract to class
  def configure(options)
    defaults = {
      display: Display::Base,
      client_name: NAME,
      client_version: VERSION,
      input: CLI::Base,
      notifier: Notifier::Base
    }
    options = defaults.merge(options)
    # set up the notifier (if there is one)
    const_set(:Notify, options[:notifier])
    const_set(:CurrentDisplay, options[:display].new)
    CurrentDisplay.start

    options
  end

  def name; Instance.client_name; end
  def version; Instance.client_version; end

  # TODO: extract to class
  # TODO: add a way to configure relay nodes
  # @return [Array] an array of action cable clients
  def setup_action_cable_clients
    client = ActionCableClient.new(
    "ws://mesh-relay-in-us-1.herokuapp.com?uid=#{Settings['uid']}",
    'MeshRelayChannel')

    client.connected { }
    client.received do |message|
      RequestProcessor.process(message[:message])
    end

    # TODO: have one client per relay node
    [client]
  end
end
