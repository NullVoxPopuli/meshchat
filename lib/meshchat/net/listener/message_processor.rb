module MeshChat
  module Net
    module Listener
      module MessageProcessor

        module_function

        def process(encoded_message)
          request = Request.new(encoded_message)
          message = request.message

          # TODO: wrap in debug if check
          Display.debug('RECEIVING: ' + message.type)
          Display.debug('RECEIVING: ' + message.sender.to_s)
          Display.debug('RECEIVING: ' + message.message.to_s)

          # handle the message
          Display.present_message message

          # then update the sender info in the db
          update_sender_info(request.json)
        end

        def update_sender_info(json)
          sender = json['sender']

          # if the sender isn't currently marked as active,
          # perform the server list exchange
          node = Node.find_by_uid(sender['uid'])
          raise Errors::Forbidden.new if node.nil?

          unless node.online?
            node.update(online: true)
            payload = Message::NodeListHash.new
            Client.send(
              location: sender['location'],
              message: payload)
          end

          # update the node's location/alias
          # as they can change this info willy nilly
          node.update(
            location: sender['location'],
            alias_name: sender['alias']
          )
        end
      end
    end
  end
end
