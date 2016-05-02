# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Base do
  let(:klass) { Meshchat::Ui::Command::Base }

  describe '#handle' do
    it 'is not implemented' do
      i = klass.new('/blegh', nil, nil, nil)
      expect(i.handle).to eq 'not implemented...'
    end

    it 'is implemented' do
      input_factory = Meshchat::Ui::CLI::InputFactory.new(nil, nil, nil)
      i = klass.new('/config set', nil, nil, input_factory)
      expect(i.handle).to_not eq 'not implemented...'
    end
  end

  describe '#sub_command_args' do
    it 'returns args of a sub command' do
      i = klass.new('/config set alias something', nil, nil, nil)
      expect(i.send(:sub_command_args)).to eq %w(alias something)
    end
  end
end
