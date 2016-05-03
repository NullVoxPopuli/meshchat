# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::Factory do
  let(:klass) { Meshchat::Network::Message::Factory }

  before(:each) do
    mock_settings_objects
  end

  describe '#create' do
    it 'sets my sender defaults' do
      f = klass.new('not a dispatcher')
      m = f.create('chat')

      expect(m.sender_name).to eq Meshchat::APP_CONFIG.user['alias']
      expect(m.sender_location).to eq Meshchat::APP_CONFIG.user.location
      expect(m.sender_uid).to eq Meshchat::APP_CONFIG.user['uid']
    end

    context 'whisper' do
      let(:factory) { klass.new('not a dispatcher') }
      describe '#display' do
        it 'includes the "to" name' do
          m = factory.create(
            Meshchat::Network::Message::WHISPER,
            data: {
              message: 'message',
              to: 'target'
            })

          expect(m._to).to eq 'target'
        end

        it 'includes the "from" name' do
          m = factory.create(
            Meshchat::Network::Message::WHISPER,
            data: {
              message: 'message',
              to: 'target'
            })

          expect(m.sender_name).to eq Meshchat::APP_CONFIG.user['alias']
        end
      end
    end
  end
end
