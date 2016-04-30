# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Identity do
  let(:klass) { Meshchat::Ui::Command::Identity }

  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/identity', nil, nil, nil)
      # there isn't really a beneficial way to test this,
      # but it does make sure that there are no errors
      expect(c.handle).to eq Meshchat::APP_CONFIG.user.identity
    end
  end
end
