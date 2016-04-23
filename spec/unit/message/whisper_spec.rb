require 'spec_helper'

describe MeshChat::Message::Whisper do
  let(:klass) { MeshChat::Message::Whisper }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message){}
  end

  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end

    it 'sets the default sender' do
      m = klass.new
      expect(m.sender_name).to eq MeshChat::Settings['alias']
      expect(m.sender_location).to eq MeshChat::Settings.location
      expect(m.sender_uid).to eq MeshChat::Settings['uid']
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
