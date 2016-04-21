require 'spec_helper'

describe MeshChat::CLI do
  let(:klass) { MeshChat::CLI }

  before(:each) do
    mock_settings_objects
  end

  context 'initialize' do
    it 'does not error' do
      expect do
        klass.new(nil, nil)
      end.to_not raise_error
    end
  end
end
