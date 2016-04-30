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
      m = f.create(type: 'chat')

      expect(m.sender_name).to eq Meshchat::APP_CONFIG.user['alias']
      expect(m.sender_location).to eq Meshchat::APP_CONFIG.user.location
      expect(m.sender_uid).to eq Meshchat::APP_CONFIG.user['uid']
    end
  end
end
