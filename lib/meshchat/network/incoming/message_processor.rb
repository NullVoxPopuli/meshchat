# frozen_string_literal: true
module Meshchat
  module Network
    module Incoming
      # decodes an encrypted message and handles it.
      # also update's the info of the sender
      class MessageProcessor
        attr_reader :_network, :_location
        attr_reader :_message_factory, :_message_dispatcher

        def initialize(network: NETWORK_LOCAL, message_dispatcher: nil, location: nil)
          @_network = network
          @_message_dispatcher = message_dispatcher
          @_message_factory = message_dispatcher._message_factory
          @_location = location
        end

        # @param [String] encoded_message - the encrypted message as a string
        def process(encoded_message)
          request = MessageDecryptor.new(encoded_message, _message_factory)
          message = request.message

          Debug.receiving_message(message)

          # show the message to the user, and update the information
          # we have on the sender, so that we may reply to the
          # correct location
          update_sender_info(request._json)
          Display.present_message message
        end

        # @param [String] encoded_message - the encrypted message as a string
        def update_sender_info(json)
          sender = json['sender']
          # Note that sender['location'] should always reference
          # the sender's local network address
          network_location = sender['location']

          # if the sender isn't currently marked as active,
          # perform the server list exchange
          node = Node.find_by_uid(sender['uid'])
          raise Errors::Forbidden, 'node not found' if node.nil?

          # if we are receiving a message from a node we had previously
          # known to be offline, we need to do the node list hash dance
          # with them to see if they know of any new members to the network
          unless node.online?
            node.update(on_local_network: true) if is_processing_for_local?
            node.update(on_relay: true) if is_processing_for_relay?

            nlh = _message_factory.create(Message::NODE_LIST_HASH)
            _message_dispatcher.send_message(node: node, message: nlh)
          end

          # update the node's location/alias
          # as they can change this info willy nilly
          attributes = {
            location_on_network: network_location,
            alias_name: sender['alias']
          }
          attributes[:location_of_relay] = _location if is_processing_for_relay?
          node.update(attributes)
        end

        def is_processing_for_relay?
          _network == NETWORK_RELAY
        end

        def is_processing_for_local?
          _network != NETWORK_RELAY
        end
      end
    end
  end
end
