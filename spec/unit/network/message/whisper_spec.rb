# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::Whisper do
  let(:klass) { Meshchat::Network::Message::Whisper }
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message) {}
  end

  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end

  context 'display' do
    it 'does not show to on received whispers' do
      msg = klass.new
      s = msg.display
      expect(s).to_not include('->')
    end

    it 'does show the to' do
      msg = klass.new(to: 'you')
      s = msg.display
      expect(s).to include('->')
    end
  end
end
