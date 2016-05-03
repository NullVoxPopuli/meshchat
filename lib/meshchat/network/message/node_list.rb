# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class NodeList < Base
        def message
          @message ||= Node.as_json
        end

        def handle
          respond
          nil
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
            respond_with_what_we_have(we_only_have, they_only_have, uid)
          else
            respond_with_confirmation_of_in_sync(uid)
          end
        end

        def respond_with_confirmation_of_in_sync(uid)
          Display.debug 'node lists are in sync'
          nlh_message = _message_factory.create(NODE_LIST_HASH)
          # lists are in sync, confirm with hash
          _message_dispatcher.send_message(uid: uid, message: nlh_message)
        end

        def respond_with_what_we_have(we_only_have, they_only_have, uid)
          Display.debug 'we have nodes that they do not'

          we_only_have_message = _message_factory.create(
            NODE_LIST_DIFF,
            data: { message: we_only_have })

          they_only_have_message = _message_factory.create(
            NODE_LIST_DIFF,
            data: { message: they_only_have })

          # give the sender our list
          _message_dispatcher.send_message(
            uid: uid,
            message: we_only_have_message
          )

          # give people we know about
          # (but the sender of the Node List may not know about)
          # our node list diff
          Node.online.each do |node|
            _message_dispatcher.send_message(
              node: node,
              message: they_only_have_message)
          end
        end
      end
    end
  end
end
