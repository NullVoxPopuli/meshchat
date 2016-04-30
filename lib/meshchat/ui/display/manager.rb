# frozen_string_literal: true
module Meshchat
  module Ui
    module Display
      class Manager
        attr_accessor :_ui

        delegate :start, to: :_ui
        delegate :add_line, to: :_ui
        delegate :info, to: :_ui
        delegate :emote, to: :_ui
        delegate :warning, to: :_ui
        delegate :alert, to: :_ui
        delegate :success, to: :_ui
        delegate :chat, to: :_ui
        delegate :whisper, to: :_ui

        attr_accessor :_logger
        delegate :fatal, to: :_logger
        delegate :debug, to: :_logger
        delegate :error, to: :_logger

        def initialize(ui_klass)
          self._logger = Logger.new('debug.log')
          self._ui = ui_klass.new
        end

        def present_message(message)
          result = message.handle
          return unless result

          case message.class.name
          when Network::Message::Chat.name
            chat result
            notify(summary: message.sender_name, body: message.message)
          when Network::Message::Whisper.name
            whisper result
            notify(summary: message.sender_name, body: message.message)
          when Network::Message::Emote.name
            emote result
            notify(summary: message.sender_name, body: message.message)
          when Network::Message::PingReply.name, Network::Message::Ping.name
            info result
          when Network::Message::NodeList.name,
               Network::Message::NodeListDiff.name,
               Network::Message::NodeListHash.name
            # display nothing
          else
            add_line result
          end
        end

        def notify(*args)
          Notify.show(*args) if defined? Notify and Notify
        end
      end
    end
  end
end
