module MeshChat
  class Configuration
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :HashFile
      autoload :Settings
      autoload :Identity
      autoload :AppConfig
    end
  end
end
