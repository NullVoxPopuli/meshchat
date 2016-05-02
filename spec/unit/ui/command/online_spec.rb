# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Online do
  let(:klass) { Meshchat::Ui::Command::Online }

  before(:each) do
    mock_settings_objects
  end

  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/online', nil, nil, nil)
      expect(Meshchat::Node).to receive(:online).and_call_original
      c.handle
    end
  end
end
