require 'spec_helper'

describe MeshChat::Net::Listener::Request do
  let(:klass) { MeshChat::Net::Listener::Request }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end

  describe '#process_json' do
    before(:each) do
      allow_any_instance_of(klass).to receive(:listen){}
    end

    it 'whisper' do
      json = '{
        "type":"whisper",
        "message":"yo",
        "client":"Spiced Gracken",
        "client_version":"0.1.2",
        "time_sent":"2015-09-30 09:04:59 -0400",
        "sender":{
          "alias":"nvp",
          "location":"localhost:8081",
          "uid":"1"
        }
      }'
      json = Base64.encode64(json)
      s = klass.new(json, message_dispatcher)
      s.send(:process_json)
      expect(s.message.display).to include("nvp")
      expect(s.message.display).to include("yo")
    end
  end
end
