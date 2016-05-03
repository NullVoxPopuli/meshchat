# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class Factory
        # The left side of this map is all the
        # lowercase un-underscored variant of
        # the constant name
        #
        # e.g.: NODE_LIST == 'nodelist'
        TYPES = {
          CHAT           => Chat,
          EMOTE          => Emote,
          WHISPER        => Whisper,
          DISCONNECT     => Disconnect,
          PING           => Ping,
          PING_REPLY     => PingReply,
          NODE_LIST      => NodeList,
          NODE_LIST_DIFF => NodeListDiff,
          NODE_LIST_HASH => NodeListHash
        }.freeze

        # the message dispatcher that is responsible for
        # dispatching messages across either network
        attr_accessor :_dispatcher
        attr_accessor :_common_parameters

        def initialize(dispatcher)
          @_dispatcher        = dispatcher
          @_common_parameters = {
            message_dispatcher: _dispatcher,
            message_factory:    self
          }
        end

        # If data contains the payload key, we are receiving the message.
        # If data does not caine the payload key, we are buliding the message
        # to send
        def create(type = '', data: {})
          return Debug.message_type_not_found(type + 'not found') if type.blank?
          data = data.deep_symbolize_keys

          parameters = parameters_for(data)
          klass = TYPES[type]
          raise Errors::MessageTypeNotRecognized unless klass
          klass.new(parameters)
        end

        def parameters_for(data)
          if is_receiving?(data)
            receiving_parameters_for(data)
          else
            sending_parameters_for(data)
          end
        end

        def is_receiving?(data)
          data[:payload].present?
        end

        # ensures a payload exists, as well as assigns the
        # message dispatcher and message factory
        def receiving_parameters_for(data)
          { payload: data[:payload] }.merge(_common_parameters)
        end

        def sending_parameters_for(data)
          data.merge(
            message: data[:message],
            sender: {
              'alias'    => APP_CONFIG.user['alias'],
              'location' => APP_CONFIG.user.location,
              'uid'      => APP_CONFIG.user['uid']
            }
          )
        end
      end
    end
  end
end
