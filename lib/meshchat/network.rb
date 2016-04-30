module MeshChat
  module Network
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :Dispatcher
    end
  end
end
