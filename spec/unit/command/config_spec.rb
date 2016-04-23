require 'spec_helper'

describe MeshChat::Command::Config do
  let (:klass){ MeshChat::Command::Config }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end

  describe '#handle' do
    context 'set' do
      it 'sets the value' do
        c = klass.new('/config set anything toValue', message_dispatcher)
        c.handle
        expect(MeshChat::Settings['anything']).to eq 'toValue'
      end

      it 'does not pass valid params' do
        c = klass.new('/config set', message_dispatcher)
        expect(c.handle).to eq 'set requires a key and a value'
      end
    end

    context 'display' do
      it 'displays the settings' do
        c = klass.new('/config display', message_dispatcher)
        expect(c.handle).to eq MeshChat::Settings.display
      end
    end

    it 'does not recognize the command' do
      c = klass.new('/config nope', message_dispatcher)
      expect(c.handle).to eq 'config command not implemented...'
    end
  end

  describe '#config_set_args' do
    it 'returns the last two args' do
      c = klass.new('/config set arg1 arg2', message_dispatcher)
      expect(c.config_set_args).to eq ['arg1', 'arg2']
    end
  end

  describe '#is_valid_set_command?' do
    it 'requires the subcommand to be set' do
      c = klass.new('/config wat', message_dispatcher)
      expect(c.is_valid_set_command?).to eq false
    end

    it 'requires is false if less than 4 arguments' do
      c = klass.new('/config set hello', nil)
      expect(c.is_valid_set_command?).to eq false
    end

    it 'requires all arguments' do
      c = klass.new('/config set hello there', nil)
      expect(c.is_valid_set_command?).to eq true
    end

  end

end
