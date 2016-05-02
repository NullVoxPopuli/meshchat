# frozen_string_literal: true
module Meshchat
  module Configuration
    class AppConfig
      DEFAULTS = {
        display: Ui::Display::Base,
        client_name: Meshchat.name,
        client_version: Meshchat::VERSION,
        input: Ui::CLI::KeyboardLineInput,
        notifier: Ui::Notifier::Base
      }.freeze

      attr_reader :_options

      def initialize(options)
        @_options = DEFAULTS.merge(options)
        @_options[:user] = Configuration::Settings.new

        locale_path = 'lib/meshchat/locale/'
        # I18n.load_path = Dir[locale_path + '*.yml']
        I18n.backend.store_translations(:en,
          YAML.load(File.read(locale_path + 'en.yml')))

        Meshchat.const_set(:Notify, options[:notifier])

        # The display has to be created right away so that
        # we can start outputting to it
        manager = Ui::Display::Manager.new(options[:display])
        Meshchat.const_set(:Display, manager)
        Meshchat.const_set(:APP_CONFIG, self)

        Meshchat::Display.start
      end

      def validate
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
      end

      def [](key)
        _options[key]
      end

      def []=(key, value)
        _options[key] = value
      end

      def user
        _options[:user]
      end
    end
  end
end
