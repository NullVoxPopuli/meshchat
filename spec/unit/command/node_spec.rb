require 'spec_helper'

describe MeshChat::Command::IRB do
  let (:klass){ MeshChat::Command::IRB }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message){}
  end


  describe '#handle' do
    it 'alerts the user' do
      # don't actually shut down...
      expect(MeshChat::Models::Entry).to receive(:first)
      c = klass.new('/c Node.first', message_dispatcher)
      c.handle
    end
  end

end
