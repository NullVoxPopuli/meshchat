# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Ping do
  let(:klass) { Meshchat::Ui::Command::Ping }
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  let(:message_factory){ message_dispatcher._message_factory }

  before(:each) do
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message) {}
    allow(message_dispatcher._local_client).to receive(:start_server)
  end

  describe '#handle' do
    it 'cannot find the server' do
      c = klass.new('/ping alias noone', message_dispatcher, message_factory, nil)
      expect(c.handle).to eq 'noone could not be found'
    end

    it 'shows usage' do
      c = klass.new('/ping', message_dispatcher, message_factory, nil)
      expect(c.handle).to eq c.usage
    end

    it 'tries to send' do
      c = klass.new('/ping location noone', message_dispatcher, message_factory, nil)
      # does not return when sending
      expect(c.handle).to eq 'noone could not be found'
    end
  end

  describe '#lookup_field' do
    it 'is the subcommand' do
      c = klass.new('/ping alias', nil, nil, nil)
      expect(c.lookup_field).to eq c.send(:sub_command)
    end

    it 'is null if not present' do
      c = klass.new('/ping', nil, nil, nil)
      expect(c.lookup_field).to eq nil
    end
  end

  describe '#lookup_value' do
    it 'is the last arg' do
      c = klass.new('/ping alias me', nil, nil, nil)
      expect(c.lookup_value).to eq 'me'
    end

    it 'retuns nil if there is no value' do
      c = klass.new('/ping location', nil, nil, nil)
      expect(c.lookup_value).to be_nil
    end
  end

  describe '#parse_ping_command' do
    it 'when lookup field is specified' do
      c = klass.new('/ping location 1.1.1.1', nil, nil, nil)
      expect(c.parse_ping_command).to eq ['location', '1.1.1.1']
    end

    it 'when only an location is specified' do
      c = klass.new('/ping 1.1.1.1', nil, nil, nil)
      expect(c.parse_ping_command).to eq ['location', '1.1.1.1']
    end

    it 'is an alias' do
      c = klass.new('/ping me', nil, nil, nil)
      expect(c.parse_ping_command).to eq %w(alias me)
    end
  end
end
