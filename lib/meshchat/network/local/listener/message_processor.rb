module MeshChat
  module Net
    module Listener
      module MessageProcessor

        module_function

        # @param [String] encoded_message - the encrypted message as a string
        # @param [String] received_from - optional URL to override the sender ip
        # @param [Boolean] web_socket - signifies that the message came from a web socket
        def process(encoded_message, received_from: nil, web_socket: false, message_dispatcher: nil)
          request = Request.new(encoded_message, message_dispatcher)
          message = request.message

          Debug.receiving_message(message)

          # handle the message
          Display.present_message message

          # then update the sender info in the db
          update_sender_info(request.json,
            received_from: received_from,
            web_socket: web_socket,
            message_dispatcher: message_dispatcher)
        end

        # @param [String] encoded_message - the encrypted message as a string
        # @param [String] received_from - optional URL to override the sender ip
        # @param [Boolean] web_socket - signifies that the message came from a web socket
        def update_sender_info(json, received_from: nil, web_socket: false, message_dispatcher: nil)
          sender = json['sender']
          network_location = sender['location']

          # if the sender isn't currently marked as active,
          # perform the server list exchange
          node = Node.find_by_uid(sender['uid'])
          raise Errors::Forbidden.new if node.nil?

          unless node.online?
            node.update(on_local_network: true) unless web_socket
            node.update(on_relay: true) if web_socket
            payload = Message::NodeListHash.new
            message_dispatcher.send_message(location: network_location, message: payload)
          end

          # update the node's location/alias
          # as they can change this info willy nilly
          attributes = {
            # Note that sender['location'] should always reference
            # the sender's local network address
            location_on_network: network_location,
            alias_name: sender['alias']
          }
          attributes[:location_of_relay] = received_from if received_from and web_socket
          node.update(attributes)
        end
      end
    end
  end
end
