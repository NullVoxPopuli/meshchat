# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Message::PingReply do
  let(:klass) { Meshchat::Message::PingReply }

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
    it 'says that the ping was successful' do
      pending 'output disabled for pingreply'
      m = klass.new
      expect(m.display).to eq 'ping successful'
    end
  end
end
