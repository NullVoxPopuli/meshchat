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
      result = m.display
      expect(result).to be_a_kind_of(Hash)
    end
  end
end
