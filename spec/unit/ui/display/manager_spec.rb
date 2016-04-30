# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Display::Manager do
  let (:klass) { Meshchat::Ui::Display::Manager }
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end

  describe '#present_message' do
    it 'invokes chat' do
      expect(Meshchat::CurrentDisplay).to receive(:chat)
      m = Meshchat::Message::Chat.new
      Meshchat::CurrentDisplay.present_message(m)
    end

    it 'invokes whisper' do
      expect(Meshchat::CurrentDisplay).to receive(:whisper)
      m = Meshchat::Message::Whisper.new
      Meshchat::CurrentDisplay.present_message(m)
    end

    it 'invokes info' do
      pending 'output disabled for pingreply'
      expect(Meshchat::CurrentDisplay).to receive(:info)
      m = Meshchat::Message::PingReply.new
      Meshchat::CurrentDisplay.present_message(m)
    end

    it 'invokes add_line for other menssages' do
      expect(Meshchat::CurrentDisplay).to receive(:add_line)
      m = Meshchat::Message::Disconnect.new
      Meshchat::CurrentDisplay.present_message(m)
    end
  end
end
