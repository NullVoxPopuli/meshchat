# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Exit do
  let(:klass) { Meshchat::Ui::Command::Exit }

  describe '#handle' do
    it 'alerts the user' do
      # don't actually shut down...
      input_factory = Meshchat::Ui::CLI::InputFactory.new(nil, nil, nil)
      expect(input_factory._cli).to receive(:shutdown)
      c = klass.new('/exit', nil, nil, input_factory)
      c.handle
    end
  end
end
