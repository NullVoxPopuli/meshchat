require 'spec_helper'

describe MeshChat::Command::Base do
  let (:klass){ MeshChat::Command::Base }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message){}
  end

  describe '#handle' do
    it 'is not implemented' do
      i = klass.new('/blegh', message_dispatcher)
      expect(i.handle).to eq 'not implemented...'
    end

    it 'is implemented' do
      i = klass.new('/config set', message_dispatcher)
      expect(i.handle).to_not eq 'not implemented...'
    end
  end

  describe '#sub_command_args' do
    it 'returns args of a sub command' do
      i = klass.new('/config set alias something', message_dispatcher)
      expect(i.send(:sub_command_args)).to eq ['alias', 'something']
    end
  end

end
