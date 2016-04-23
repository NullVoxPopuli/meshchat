require 'spec_helper'

describe MeshChat::Command::Online do
  let (:klass){ MeshChat::Command::Online }

  before(:each) do
    mock_settings_objects
  end


  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/online', nil)
      #expect(c.handle).to eq MeshChat::ActiveServers.who
    end
  end

end
