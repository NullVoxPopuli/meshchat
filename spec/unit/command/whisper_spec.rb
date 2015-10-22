require 'spec_helper'

describe MeshChat::Command::Whisper do
  let (:klass){ MeshChat::Command::Whisper }

  before(:each) do
    mock_settings_objects
  end

  describe '#target' do
    it 'gets the target' do
      c = klass.new('@target yo')
      expect(c.target).to eq 'target'
    end

    it 'returns nil' do
      # TODO: maybe this is what triggers whisper mode
      c = klass.new('@')
      expect(c.target).to eq nil
    end
  end

  describe '#message' do
    it 'returns nil' do
      c = klass.new('@')
      expect(c.message).to eq nil
    end

    it 'returns empty string with a target' do
      c = klass.new('@target')
      expect(c.message).to eq ''
    end

    it 'returns the message' do
      c = klass.new('@target hello there')
      expect(c.message).to eq 'hello there'
    end
  end

  describe '#handle' do
    context 'no target' do
      it 'alerts the user' do
        c = klass.new('@target something')
        expect(c.handle).to eq 'node for target not found or is not online'
      end
    end

    context 'target found' do
      before(:each) do
        MeshChat::Models::Entry.create(
          alias_name: 'alias',
          location: '1.1.1.1:1111',
          uid: '1',
          public_key: '123'
        )
      end

      it 'sends the message' do
        expect(MeshChat::Net::Client).to receive(:send)

        c = klass.new('@alias hi, how are ya?')
        c.handle
      end
    end
  end

end