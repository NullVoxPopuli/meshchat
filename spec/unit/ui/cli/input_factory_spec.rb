# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::CLI::InputFactory do
  let(:klass) { Meshchat::Ui::CLI::InputFactory }
  let(:message_dispatcher) { Meshchat::Network::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message) {}
  end
  describe '#create' do
    it 'creates a command' do
      result = klass.create('/anything', message_dispatcher)
      expect(result).to be_kind_of(Meshchat::Command::Base)
    end

    it 'creates a whisper' do
      result = klass.create('@anybody', message_dispatcher)
      expect(result).to be_kind_of(Meshchat::Command::Whisper)
    end

    it 'creates a generic input' do
      result = klass.create('chat', message_dispatcher)
      expect(result).to be_kind_of(klass)
    end
  end

  describe '#handle' do
    it 'has no servers' do
      i = klass.create('hi there', message_dispatcher)
      expect(i.handle).to eq 'you have no servers'
    end

    context 'has servers' do
      before(:each) do
        Meshchat::Models::Entry.new(
          alias_name: 'test',
          location_on_network: '1.1.1.1:1111',
          uid: '1',
          public_key: '10'
        ).save!

        # expect(Meshchat::Net::Client).to receive(:send_to_and_close)
      end

      it 'displays the message' do
        msg = 'hi test'
        expect(Meshchat::Display).to receive(:chat)
        i = klass.create(msg, message_dispatcher)
        i.handle
      end

      skip 'renders the message to json' do
        pending('how to test?')
        msg = 'hi test'
        # expect_any_instance_of(Meshchat::Message::Chat).to receive(:display)
        i = klass.create(msg, message_dispatcher)
        i.handle
      end
    end
  end
end
