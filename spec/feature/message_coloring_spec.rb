
require 'spec_helper'

describe 'Message Coloring' do
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end

  describe 'chats' do
    context 'are received' do
      before(:each) do
        allow_any_instance_of(MeshChat::Net::Listener::Server).to receive(:listen){}

        json = '{"type":"chat","message":"hi","client":"Spiced Gracken","client_version":"0.1.2","time_sent":"2015-09-30 10:36:13 -0400","sender":{"alias":"nvp","location":"nvp","uid":"1"}}'
        json = Base64.encode64(json)
        s = MeshChat::Net::Listener::Request.new(json, message_dispatcher)
        s.send(:process_json)
        @msg = s.message
        expect(@msg.display).to include("nvp")
        expect(@msg.display).to include("hi")
      end

      it 'is forwarded to the chat colorizer' do
        expect(MeshChat::CurrentDisplay).to receive(:chat)
        MeshChat::CurrentDisplay.present_message @msg
      end
    end
  end
end
