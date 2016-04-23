require 'spec_helper'

describe MeshChat::Command::Ping do
  let (:klass){ MeshChat::Command::Ping }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message){}
  end

  describe '#handle' do
    before(:each) do
      allow(message_dispatcher).to receive(:send_message)
    end

    it 'cannot find the server' do
      c = klass.new('/ping alias noone', message_dispatcher)
      expect(c.handle).to eq ('noone could not be found')
    end

    it 'shows usage' do
      c = klass.new('/ping', message_dispatcher)
      expect(c.handle).to eq c.usage
    end

    it 'tries to send' do
      c = klass.new('/ping location noone', message_dispatcher)
      # does not return when sending
      expect(c.handle).to eq 'noone could not be found'
    end
  end

  describe '#lookup_field' do
    it 'is the subcommand' do
      c = klass.new('/ping alias', message_dispatcher)
      expect(c.lookup_field).to eq c.send(:sub_command)
    end

    it 'is null if not present' do
      c = klass.new('/ping', message_dispatcher)
      expect(c.lookup_field).to eq nil
    end
  end

  describe '#lookup_value' do
    it 'is the last arg' do
      c = klass.new('/ping alias me', message_dispatcher)
      expect(c.lookup_value).to eq 'me'
    end

    it 'retuns nil if there is no value' do
      c = klass.new('/ping location', message_dispatcher)
      expect(c.lookup_value).to be_nil
    end
  end

  describe '#parse_ping_command' do
    it 'when lookup field is specified' do
      c = klass.new('/ping location 1.1.1.1', message_dispatcher)
      expect(c.parse_ping_command).to eq ['location', '1.1.1.1']
    end

    it 'when only an location is specified' do
      c = klass.new('/ping 1.1.1.1', message_dispatcher)
      expect(c.parse_ping_command).to eq ['location', '1.1.1.1']
    end

    it 'is an alias' do
      c = klass.new('/ping me', message_dispatcher)
      expect(c.parse_ping_command).to eq ['alias', 'me']
    end
  end
end
