module MeshChat
  class Configuration

    DEFAULTS = {
      display: Display::Base,
      client_name: NAME,
      client_version: VERSION,
      input: CLI::KeyboardLineInput,
      notifier: Notifier::Base
    }

    attr_reader :_options

    def initialize(options)
      @_options = DEFAULTS.merge(options)

      MeshChat.const_set(:Notify, options[:notifier])
      MeshChat.const_set(:CurrentDisplay, options[:display].new)
      MsehChat.const_set(:APP_CONFIG, self)

      CurrentDisplay.start
    end

    def [](key)
      _options[key]
    end

  end
end
