require 'spec_helper'

describe MeshChat::Command::Identity do
  let (:klass){ MeshChat::Command::Identity }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end


  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/identity', message_dispatcher)
      # there isn't really a beneficial way to test this,
      # but it does make sure that there are no errors
      expect(c.handle).to eq MeshChat::Settings.identity
    end
  end

end
