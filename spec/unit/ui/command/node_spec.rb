# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Irb do
  let(:klass) { Meshchat::Ui::Command::Irb }

  before(:each) do
    mock_settings_objects
  end

  describe '#handle' do
    it 'alerts the user' do
      # don't actually shut down...
      expect(Meshchat::Node).to receive(:first)
      c = klass.new('/c Node.first', nil, nil, nil)
      c.handle
    end
  end
end
