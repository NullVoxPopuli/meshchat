module MeshChat
  class Configuration

    DEFAULTS = {
      display: Display::Base,
      client_name: MeshChat.name,
      client_version: VERSION,
      input: CLI::KeyboardLineInput,
      notifier: Notifier::Base
    }

    attr_reader :_options

    def initialize(options)
      @_options = DEFAULTS.merge(options)

      locale_path = 'lib/meshchat/locale/'
      # I18n.load_path = Dir[locale_path + '*.yml']
      I18n.backend.store_translations(:en ,
        YAML.load(File.read(locale_path + 'en.yml')))

      MeshChat.const_set(:Notify, options[:notifier])

      # The display has to be created right away so that
      # we can start outputting to it
      display = options[:display].new
      manager = Display::Manager.new(options[:display])
      MeshChat.const_set(:CurrentDisplay, manager)

      MeshChat.const_set(:APP_CONFIG, self)

      CurrentDisplay.start
    end

    def [](key)
      _options[key]
    end

  end
end
