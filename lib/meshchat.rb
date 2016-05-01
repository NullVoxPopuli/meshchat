# frozen_string_literal: true
# required standard libs
require 'openssl'
require 'socket'
require 'json'
require 'date'
require 'colorize'
require 'io/console'
require 'readline'
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

require 'meshchat/version'

# debug logging....
# ^ at least util 'all' scenarios are captured via tests
# TODO: look in to how Active Support does logging
require 'meshchat/debug'

module Meshchat
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Encryption
    autoload :Ui
    autoload :Node, 'meshchat/models/node'
    autoload :Network
    autoload :Configuration
  end

  module_function

  # @param [Hash] overrides
  # @option overrides [Proc] on_display_start what to do upon start of the display manager
  # @option overrides [class] display the display ui to use inherited from Display::Base
  def start(overrides = {})
    app_config = Configuration::AppConfig.new(overrides)
    app_config.validate

    # if everything is configured correctly, boot the app
    # this handles all of the asyncronous stuff
    EventMachine.run do
      bootstrap_runloop(app_config)
    end
  end

  def bootstrap_runloop(app_config)
    # 1. hook up the display / output 'device'
    #    - responsible for notifications
    #    - created in Configuration
    display = Display

    # 2. create the message dispatcher
    #    - boots the local and relay network connections
    #    - sends the messages out to the network
    #    - tries p2p first, than uses the relays
    message_dispatcher = Network::Dispatcher.new

    # 3. hook up the keyboard / input 'device'
    #    - tesponsible for parsing input
    input_receiver = Ui::CLI.new(
      message_dispatcher,
      message_dispatcher._message_factory,
      display)

    # by default the app_config[:input] is
    # Meshchat::Cli::KeyboardLineInput
    EM.open_keyboard(app_config[:input], input_receiver)
  end
end
