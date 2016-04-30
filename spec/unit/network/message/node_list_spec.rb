# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::NodeList do
  let(:klass) { Meshchat::Network::Message::NodeList }
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

  describe '#handle' do
    it 'calls respond' do
      msg = klass.new(message: 'hash')
      expect(msg).to receive(:respond)
      expect(msg.handle).to be_nil
    end
  end

  describe '#respond' do
    it 'sends a message' do
      expect(message_dispatcher).to receive(:send_message)

      expect(Meshchat::Node).to receive(:diff) {
        [[{
          'alias' => 'hi',
          'location' => '2.2.2.2:222',
          'uid' => '222',
          'publickey' => '1233333'
        }], []]
      }

      msg = klass.new(message_dispatcher: message_dispatcher)
      msg.respond
    end

    it 'sendsa  node list hash as confirmation that lists are in sync' do
      expect(message_dispatcher).to receive(:send_message)
      expect(Meshchat::Network::Message::NodeListHash).to receive(:new)
      msg = klass.new(message_dispatcher: message_dispatcher)
      msg.respond
    end
  end
end
