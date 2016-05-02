# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Display::Manager do
  let(:klass) { Meshchat::Ui::Display::Manager }
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end

  describe '#present_message' do
    it 'invokes chat' do
      expect(Meshchat::Display).to receive(:chat)
      m = Meshchat::Network::Message::Chat.new
      Meshchat::Display.present_message(m)
    end

    it 'invokes whisper' do
      expect(Meshchat::Display).to receive(:whisper)
      m = Meshchat::Network::Message::Whisper.new
      Meshchat::Display.present_message(m)
    end

    it 'invokes add_line for other menssages' do
      expect(Meshchat::Display).to receive(:add_line)
      m = Meshchat::Network::Message::Disconnect.new
      Meshchat::Display.present_message(m)
    end
  end
end
