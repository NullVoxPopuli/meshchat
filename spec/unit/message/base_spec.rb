# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Message::Base do
  let(:klass) { Meshchat::Message::Base }

  before(:each) do
    mock_settings_objects
  end

  describe '#display' do
    it 'shows the message' do
      m = klass.new
      expect(m.display).to eq nil # no message
    end
  end

  describe '#new' do
    it 'has my sender defaults' do
      m = klass.new
      expect(m.sender_name).to eq Meshchat::Settings['alias']
      expect(m.sender_location).to eq Meshchat::Settings.location
      expect(m.sender_uid).to eq Meshchat::Settings['uid']
    end
  end
end
