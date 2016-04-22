module MeshChat
  module Message
    class Disconnect < Base
      def display
        location = payload['sender']['location']
        uid = payload['sender']['uid']
        name = payload['sender']['alias']
        node = Node.find_by_uid(uid)
        node.update(online: false) if node
        "#{name}@#{location} has disconnected"
      end
    end
  end
end
