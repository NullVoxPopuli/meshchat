module MeshChat
  module Net
    class MessageDispatcher

      # standard peer-to-peer message sending
      attr_reader :_http_client

      # the action cable client ( web socket / connection beyond the firewall)
      #  - responsible for the relay server if the http client can't find the recipient
      attr_reader :_action_cable_client

      def initialize
        self._http_client = HttpClient # do we need an instanc? :-\

        relay = MeshRelay.new
        relay.setup
        self._action_cable_client = relay
      end

      # @note Either the location, node, or uid should be present
      #
      # @param [String] location (Optional) location of target
      # @param [String] uid (Optional) uid of target
      # @param [Node] node (Optional) target
      # @param [Message] message (Required) what to send to the target
      def send_message(location: nil, uid: nil, node: nil, message: nil)
        # verify node is valid
        node = self.node_for(location: location, uid: uid, node: node)
        # don't proceed if we don't have a node
        return unless node
        # don't send to ourselves
        return if Settings['uid'] == node.uid

        # everything is valid so far... DISPATCH!
        dispatch!(node, message)
      end

      def dispatch!(node, message)
        Debug.sending_message(message)

        message = encrypted_message(node, message)

        begin
          _http_client.send_message(node.location, message)
          # TODO: eventify this, cause rescue blocks are bad.
        rescue Curl::Err::ConnectionFailedError => e
          # now try the sending the mesasge through the relay
          # TODO: don't do this if there are no relays
          _action_cable_client.send_message(node.uid, message)

          # TODO: hook in to the error hook on the relay and read if
          #       the person is not online, then set online to false.
          node.update(online: false)
          Display.info "#{node.alias_name} has ventured offline"
          Debug.person_not_online(node, message, e)
        end

        # Thread.new(node, message) do |node, message|

        # end
      end

      # @return [Node]
      def node_for(location: nil, uid: nil, node: nil)
        unless node
          node = Models::Entry.find_by_location(location) if location
          node = Models::Entry.find_by_uid(uid) if uid && !node
        end

        # TODO: also check for public key?
        # without the public key, the message is sent in cleartext. :-\
        if !(node && node.location)
          Display.alert "Node not found, or does not have a location. Have you imported #{location || ""}?"
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
