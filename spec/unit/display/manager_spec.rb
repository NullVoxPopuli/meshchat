require 'spec_helper'

describe MeshChat::Display::Manager do
  let (:klass){ MeshChat::Display::Manager }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end

  describe '#present_message' do

    it 'invokes chat' do
      expect(MeshChat::CurrentDisplay).to receive(:chat)
      m = MeshChat::Message::Chat.new
      MeshChat::CurrentDisplay.present_message(m)
    end

    it 'invokes whisper' do
      expect(MeshChat::CurrentDisplay).to receive(:whisper)
      m = MeshChat::Message::Whisper.new
      MeshChat::CurrentDisplay.present_message(m)
    end

    it 'invokes info' do
      pending 'output disabled for pingreply'
      expect(MeshChat::CurrentDisplay).to receive(:info)
      m = MeshChat::Message::PingReply.new
      MeshChat::CurrentDisplay.present_message(m)
    end

    it 'invokes add_line for other menssages' do
      expect(MeshChat::CurrentDisplay).to receive(:add_line)
      m = MeshChat::Message::Disconnect.new
      MeshChat::CurrentDisplay.present_message(m)
    end
  end

end
