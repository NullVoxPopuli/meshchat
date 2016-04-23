require 'spec_helper'

describe MeshChat::Command::Server do
  let (:klass){ MeshChat::Command::Server }

  before(:each) do
    mock_settings_objects
  end

  describe '#handle' do

    it 'shows who is online' do
      c = klass.new('/server online', nil)
      #expect(c.handle).to eq MeshChat::ActiveServers.display_locations
    end

    it 'lists the locations' do
      c = klass.new('/servers', nil)
      #expect(c.handle).to eq MeshChat::ActiveServers.display_locations
    end


  end

end
