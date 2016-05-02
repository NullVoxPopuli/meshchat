# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::CLI::InputFactory do
  let(:klass) { Meshchat::Ui::CLI::InputFactory }
  let(:dispatcher) { Meshchat::Network::Dispatcher.new }
  let(:factory) { klass.new(dispatcher, dispatcher._message_factory, 'not a cli') }
  # before(:each) do
  #   mock_settings_objects
  # end

  describe '#create' do
    it 'creates a command' do
      result = factory.create(for_input: '/anything')
      expect(result).to be_kind_of(Meshchat::Ui::Command::Base)
    end

    it 'creates a whisper' do
      result = factory.create(for_input: '@anybody')
      expect(result).to be_kind_of(Meshchat::Ui::Command::Whisper)
    end

    it 'creates a generic input' do
      result = factory.create(for_input: 'chat')
      expect(result).to be_kind_of(Meshchat::Ui::Command::Base)
    end
  end

  describe '#handle' do
    it 'has no servers' do
      i = factory.create(for_input: 'hi there')
      expect(i.handle).to eq 'you have no servers'
    end

    context 'has servers' do
      before(:each) do
        Meshchat::Node.new(
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
        i = factory.create(for_input: msg)
        expect(factory._message_dispatcher).to receive(:send_message)
        i.handle
      end
    end
  end
end
