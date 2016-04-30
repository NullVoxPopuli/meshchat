# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Message::NodeListDiff do
  let(:klass) { Meshchat::Message::NodeListDiff }

  before(:each) do
    mock_settings_objects
  end

  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end

  context '#handle' do
    it 'adds node entries we do not have' do
      msg = klass.new(message: [
                        {
                          'alias' => 'hi',
                          'location' => '2.2.2.2:222',
                          'uid' => '222',
                          'publickey' => '1233333'
                        }
                      ])

      expect do
        msg.handle
      end.to change(Meshchat::Models::Entry, :count).by 1
    end
  end
end
