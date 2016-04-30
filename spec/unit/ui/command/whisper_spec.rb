# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Whisper do
  let(:klass) { Meshchat::Ui::Command::Whisper }
  before(:each) do
    mock_settings_objects
  end

  describe '#target' do
    it 'gets the target' do
      c = klass.new('@target yo', nil, nil, nil)
      expect(c.target).to eq 'target'
    end

    it 'returns nil' do
      # TODO: maybe this is what triggers whisper mode
      c = klass.new('@', nil, nil, nil)
      expect(c.target).to eq nil
    end
  end

  describe '#message' do
    it 'returns nil' do
      c = klass.new('@', nil, nil, nil)
      expect(c.message).to eq nil
    end

    it 'returns empty string with a target' do
      c = klass.new('@target', nil, nil, nil)
      expect(c.message).to eq ''
    end

    it 'returns the message' do
      c = klass.new('@target hello there', nil, nil, nil)
      expect(c.message).to eq 'hello there'
    end
  end

  describe '#handle' do
    context 'no target' do
      it 'alerts the user' do
        c = klass.new('@target something', nil, nil, nil)
        expect(c.handle).to eq 'node for target not found or is not online'
      end
    end

    context 'target found' do
      before(:each) do
        Meshchat::Node.create(
          alias_name: 'alias',
          location_on_network: '1.1.1.1:1111',
          uid: '1',
          public_key: '123'
        )
      end

      it 'sends the message' do
        dispatcher = Meshchat::Network::Dispatcher.new
        message_factory = Meshchat::Network::Message::Factory.new(dispatcher)
        expect(dispatcher).to receive(:send_message)

        c = klass.new('@alias hi, how are ya?',
          dispatcher,
          message_factory,
          nil)

        c.handle
      end
    end
  end
end
