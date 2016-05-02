# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Server do
  let(:klass) { Meshchat::Ui::Command::Server }

  before(:each) do
    mock_settings_objects
  end

  describe '#handle' do
    it 'shows who is online' do
      klass.new('/server online', nil, nil, nil)
      # expect(c.handle).to eq Meshchat::ActiveServers.display_locations
    end

    it 'lists the locations' do
      klass.new('/servers', nil, nil, nil)
      # expect(c.handle).to eq Meshchat::ActiveServers.display_locations
    end
  end
end
