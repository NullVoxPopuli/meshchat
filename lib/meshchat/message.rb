require 'meshchat/message/base'
require 'meshchat/message/chat'
require 'meshchat/message/emote'
require 'meshchat/message/ping'
require 'meshchat/message/ping_reply'
require 'meshchat/message/disconnect'
require 'meshchat/message/whisper'
require 'meshchat/message/node_list'
require 'meshchat/message/node_list_diff'
require 'meshchat/message/node_list_hash'

module MeshChat
  module Message
    CHAT = 'chat'
    EMOTE = 'emote'
    PING = 'ping'
    PING_REPLY = 'pingreply'
    WHISPER = 'whisper'
    DISCONNECT = 'disconnect'

    NODE_LIST = 'nodelist'
    NODE_LIST_HASH = 'nodelisthash'
    NODE_LIST_DIFF = 'nodelistdiff'

    TYPES = {
      CHAT => Chat,
      EMOTE => Emote,
      WHISPER => Whisper,
      DISCONNECT => Disconnect,
      PING => Ping,
      PING_REPLY => PingReply,
      NODE_LIST => NodeList,
      NODE_LIST_DIFF => NodeListDiff,
      NODE_LIST_HASH => NodeListHash
    }


  end
end
