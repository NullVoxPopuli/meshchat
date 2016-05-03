# frozen_string_literal: true
module Meshchat
  module Network
    class Dispatcher
      # creates messages
      attr_reader :_message_factory

      # standard peer-to-peer message sending
      attr_reader :_local_client

      # the action cable client ( web socket / connection beyond the firewall)
      #  - responsible for the relay server if the http client can't find the recipient
      attr_reader :_relay_client

      def initialize
        @_message_factory = Message::Factory.new(self)
        @_local_client = Local::Connection.new(self, @_message_factory)
        @_relay_client = Remote::Connection.new(self, @_message_factory)
      end

      # @note Either the location, node, or uid should be present
      #
      # @param [String] location (Optional) location of target
      # @param [String] uid (Optional) uid of target
      # @param [Node] node (Optional) target
      # @param [Message] message (Required) what to send to the target
      def send_message(location: nil, uid: nil, node: nil, message: nil)
        # verify node is valid
        node = Node.for(location: location, uid: uid, node: node)
        # don't proceed if we don't have a node
        return unless node
        # don't send to ourselves
        return if APP_CONFIG.user['uid'] == node.uid

        # everything is valid so far... DISPATCH!
        dispatch!(node, message)
      end

      private

      def dispatch!(node, message)
        Debug.sending_message(message)

        message = encrypted_message(node, message)

        # determine last known sending method
        if node.on_local_network?
          try_dispatching_over_local_network_first(node, message)
        else
          try_dispatching_over_the_relay_first(node, message)
        end
      end

      # this attempts to send over http to the local network,
      # if that fails, the passed block will be invoked
      def try_dispatching_over_local_network_first(node, message)
        _local_client.send_message(node, message) do
          Debug.not_on_local_network(node)
          node.update(on_local_network: false)
          _relay_client.send_message(node, message)
        end
      end

      # this attempts to send over the relay first
      # if that fails, the passed block will be invked
      def try_dispatching_over_the_relay_first(node, message)
        # Due to the constant-connection nature of web-sockets,
        # The sending via http client will happen if the node's-
        # on_local_network property is true.
        # node.update(on_local_network: true)
        _relay_client.send_message(node, message)
      end

      def encrypted_message(node, message)
        message.encrypt_for(node)
      rescue => e
        Display.debug e.message
        Display.debug e.backtrace
        Debug.encryption_failed(node)
      end
    end
  end
end
