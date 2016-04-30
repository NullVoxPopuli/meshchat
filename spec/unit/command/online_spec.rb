# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Command::Online do
  let (:klass) { Meshchat::Command::Online }

  before(:each) do
    mock_settings_objects
  end

  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/online', nil)
      # expect(c.handle).to eq Meshchat::ActiveServers.who
    end
  end
end
