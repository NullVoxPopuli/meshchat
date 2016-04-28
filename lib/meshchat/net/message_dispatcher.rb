module MeshChat
  module Net
    class MessageDispatcher

      # standard peer-to-peer message sending
      attr_reader :_http_client

      # the action cable client ( web socket / connection beyond the firewall)
      #  - responsible for the relay server if the http client can't find the recipient
      attr_reader :_action_cable_client

      def initialize
        @_http_client = HttpClient # do we need an instance? :-\

        relay = Relay.new(self)
        relay.setup
        @_action_cable_client = relay
      end

      # @note Either the location, node, or uid should be present
      #
      # @param [String] location (Optional) location of target
      # @param [String] uid (Optional) uid of target
      # @param [Node] node (Optional) target
      # @param [Message] message (Required) what to send to the target
      def send_message(location: nil, uid: nil, node: nil, message: nil)
        # verify node is valid
        node = node_for(location: location, uid: uid, node: node)
        # don't proceed if we don't have a node
        return unless node
        # don't send to ourselves
        return if Settings['uid'] == node.uid

        # everything is valid so far... DISPATCH!
        dispatch!(node, message)
      end

      private

      def dispatch!(node, message)
        Debug.sending_message(message)

        message = encrypted_message(node, message)

        # determine last known sending method
        # if node.on_local_network?
          # try_dispatching_over_local_network_first(node, message)
        # else
          try_dispatching_over_the_relay_first(node, message)
        # end
      end

      # this attempts to send over http to the local network,
      # if that fails, the passed block will be invoked
      def try_dispatching_over_local_network_first(node, message)
        _http_client.send_message(node, message) do
          Debug.not_on_local_network(node)
          node.update(on_local_network: false)
          _action_cable_client.send_message(node, message)
        end
      end

      # this attempts to send over the relay first
      # if that fails, the passed block will be invked
      def try_dispatching_over_the_relay_first(node, message)
        # Due to the constant-connection nature of web-sockets,
        # The sending via http client will happen if the node's-
        # on_local_network property is true.
        # node.update(on_local_network: true)
        _action_cable_client.send_message(node, message)
      end

      # Try to find the node, given a location, or uid
      #
      # TODO: do we want to also be able to find by relay address?
      #       - this would be non-unique
      #       - maybe finding should only happen via UID
      # @param [String] location - the local network address
      # @param [String] uid - the node's UID
      # @param [Node] node - the node
      # @return [Node]
      def node_for(location: nil, uid: nil, node: nil)
        unless node
          node = Node.find_by_location_on_network(location) if location
          node = Node.find_by_uid(uid) if uid && !node
        end

        # TODO: also check for public key?
        # without the public key, the message is sent in cleartext. :-\
        if !(node && node.location)
          Display.alert "Node not found, or does not have a location. Have you imported #{location || uid || ""}?"
          return
        end

        node
      end

      def encrypted_message(node, message)
        begin
          request = MeshChat::Net::Request.new(node, message)
          return request.payload
        rescue => e
          Debug.encryption_failed(node)
        end
      end
    end
  end
end
