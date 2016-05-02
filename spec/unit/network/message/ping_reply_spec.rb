# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::PingReply do
  let(:klass) { Meshchat::Network::Message::PingReply }

  before(:each) do
    mock_settings_objects
  end

  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end
end
