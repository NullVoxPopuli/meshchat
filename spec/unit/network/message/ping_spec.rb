# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::Ping do
  let(:klass) { Meshchat::Network::Message::Ping }
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  let(:message_factory) { message_dispatcher._message_factory }
  before(:each) do
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
    allow(message_dispatcher._local_client).to receive(:start_server)
  end

  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end

  context 'display' do
    it 'displays who pinged' do
      msg = klass.new(message_dispatcher: message_dispatcher)
      msg.payload = {
        'sender' => {
          'alias' => 'me',
          'location' => 'here'
        }
      }

      expect(msg.display).to include('me@here pinged you.')
    end
  end

  context '#handle' do
    it 'calls respond' do
      msg = klass.new
      msg.payload = {
        'sender' => {
          'alias' => 'me',
          'location' => 'here'
        }
      }
      expect(msg).to receive(:respond)
      expect(msg.handle).to include('me@here pinged you.')
    end
  end

  context 'respond' do
    it 'shoots off a ping reply to the sender of the ping' do
      msg = klass.new(message_dispatcher: message_dispatcher, message_factory: message_factory)
      msg.respond
    end
  end
end
