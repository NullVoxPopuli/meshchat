# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :Base
        autoload :Chat
        autoload :Identity
        autoload :Irb
        autoload :Config
        autoload :Ping
        autoload :PingAll
        autoload :Server
        autoload :Whisper
        autoload :Exit
        autoload :SendDisconnect
        autoload :Help
        autoload :Bind
        autoload :Online
        autoload :Offline
        autoload :Share
        autoload :Import
        autoload :Emote
      end

      COMMAND_MAP = {
        Base::CONFIG          => Config,
        Base::PING            => Ping,
        Base::PING_ALL        => PingAll,
        Base::SERVERS         => Server,
        Base::SERVER          => Server,
        Base::EXIT            => Exit,
        Base::QUIT            => Exit,
        Base::IDENTITY        => Identity,
        Base::IRB             => Irb,
        Base::SHARE           => Share,
        Base::IMPORT          => Import,
        Base::EXPORT          => Share,
        Base::ONLINE          => Online,
        Base::OFFLINE         => Offline,
        Base::HELP            => Help,
        Base::BIND            => Bind,
        Base::SEND_DISCONNECT => SendDisconnect,
        Base::EMOTE           => Emote,
        Base::CHAT            => Chat
      }.freeze
    end
  end
end
