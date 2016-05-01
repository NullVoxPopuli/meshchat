# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::Chat do
  let(:klass) { Meshchat::Network::Message::Chat }

  before(:each) do
    mock_settings_objects
  end
  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end

  describe '#display' do
    before(:each) do
      payload = {
        'type' => 'chat',
        'message' => @message = 'message',
        'client' => Meshchat::APP_CONFIG[:client_name],
        'client_version' => Meshchat::VERSION,
        'time_sent' => @time = Time.now.iso8601, # not yet sent
        'sender' => {
          'alias' => @sender = 'name_of_sender',
          'location' => 'location',
          'uid' => 'uid'
        }
      }
      @msg = klass.new(payload: payload)
    end

    it 'has the time' do
      time = DateTime.parse(@time)
      expect(@msg.display[:time]).to eq time
    end

    it 'has the sender' do
      expect(@msg.display[:from]).to eq(@sender)
    end

    it 'has the message' do
      expect(@msg.display[:message]).to include(@message)
    end
  end
end
