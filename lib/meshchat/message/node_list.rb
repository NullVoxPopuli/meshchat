module MeshChat
  module Message
    class NodeList < Base
      def message
        @message ||= Node.as_json
      end

      def handle
        respond
        return
      end

      # only need to respond if this server has node entries that the
      # sender of this message doesn't have
      def respond
        received_list = message
        we_only_have, they_only_have = Node.diff(received_list)

        Display.debug('node_list#respond: me: ' + we_only_have.to_s)
        Display.debug('node_list#respond: they: ' + they_only_have.to_s)

        if they_only_have.present?
          they_only_have.each do |n|
            Node.from_json(n).save!
          end
        end

        uid = payload['sender']['uid']

        if we_only_have.present?
          Display.debug 'we have nodes that they do not'

          # give the sender our list
          message_dispatcher.send_message(
            uid: uid,
            message: NodeListDiff.new(message: we_only_have)
          )

          # give people we know about
          # (but the sender of the Node List may not know about)
          # our node list diff
          Node.online.each do |entry|
            message_dispatcher.send_message(
              node: entry,
              message: NodeListDiff.new(message: they_only_have)
            )
          end
        else
          Display.debug 'node lists are in sync'

          # lists are in sync, confirm with hash
          message_dispatcher.send_message(uid: uid, message: NodeListHash.new)
        end

      end
    end
  end
end
