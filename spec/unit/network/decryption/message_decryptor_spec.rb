# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Incoming::MessageDecryptor do
  let(:klass) { Meshchat::Network::Incoming::MessageDecryptor }
  before(:each) do
    mock_settings_objects
  end

  describe '#process_json' do
    it 'whisper' do
      message_dispatcher = Meshchat::Network::Dispatcher.new
      allow(message_dispatcher).to receive(:send_message)

      json = '{
        "type":"whisper",
        "message":"yo",
        "client":"Spiced Gracken",
        "client_version":"0.1.2",
        "time_sent":"2015-09-30 09:04:59 -0400",
        "sender":{
          "alias":"nvp",
          "location":"localhost:8081",
          "uid":"1"
        }
      }'
      json = Base64.encode64(json)
      factory = message_dispatcher._message_factory
      s = klass.new(json, factory)
      s.send(:process_json)
      expect(s._message.display[:from]).to include('nvp')
      expect(s._message.display[:message]).to include('yo')
    end
  end
end
