module MeshChat
  module Message
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Base
      autoload :Chat
      autoload :Emote
      autoload :Ping
      autoload :PingReply
      autoload :Disconnect
      autoload :Whisper
      autoload :NodeList
      autoload :NodeListDiff
      autoload :NodeListHash
      autoload :Factory
    end

    # @see https://github.com/neuravion/mesh-chat/blob/master/message-types.md
    CHAT           = 'chat'.freeze
    EMOTE          = 'emote'.freeze
    PING           = 'ping'.freeze
    PING_REPLY     = 'pingreply'.freeze
    WHISPER        = 'whisper'.freeze
    DISCONNECT     = 'disconnect'.freeze

    NODE_LIST      = 'nodelist'.freeze
    NODE_LIST_HASH = 'nodelisthash'.freeze
    NODE_LIST_DIFF = 'nodelistdiff'.freeze
  end
end
