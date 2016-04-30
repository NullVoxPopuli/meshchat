# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::Base do
  let(:klass) { Meshchat::Network::Message::Base }

  before(:each) do
    mock_settings_objects
  end

  describe '#display' do
    it 'shows the message' do
      m = klass.new
      expect(m.display).to be_blank
    end
  end
end
