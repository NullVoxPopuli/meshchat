
# frozen_string_literal: true
require 'spec_helper'

describe 'Message Coloring' do
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  let(:message_factory) { message_dispatcher._message_factory }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end

  describe 'chats' do
    context 'are received' do
      before(:each) do
        json = '{"type":"chat","message":"hi","client":"Spiced Gracken","client_version":"0.1.2","time_sent":"2015-09-30 10:36:13 -0400","sender":{"alias":"nvp","location":"nvp","uid":"1"}}'
        json = JSON.parse(json)

        @msg = message_factory.create('chat', data: { payload: json })
        expect(@msg.display[:from]).to include('nvp')
        expect(@msg.display[:message]).to include('hi')
      end

      it 'is forwarded to the chat colorizer' do
        expect(Meshchat::Display).to receive(:chat)
        Meshchat::Display.present_message @msg
      end
    end
  end
end
