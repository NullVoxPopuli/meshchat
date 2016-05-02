# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::Command::Config do
  let(:klass) { Meshchat::Ui::Command::Config }

  describe '#handle' do
    context 'set' do
      it 'sets the value' do
        c = klass.new('/config set anything toValue', nil, nil, nil)
        c.handle
        expect(Meshchat::APP_CONFIG.user['anything']).to eq 'toValue'
      end

      it 'does not pass valid params' do
        c = klass.new('/config set', nil, nil, nil)
        expect(c.handle).to eq 'set requires a key and a value'
      end
    end

    context 'display' do
      it 'displays the settings' do
        c = klass.new('/config display', nil, nil, nil)
        expect(c.handle).to eq Meshchat::APP_CONFIG.user.display
      end
    end

    it 'does not recognize the command' do
      c = klass.new('/config nope', nil, nil, nil)
      expect(c.handle).to eq 'config command not implemented...'
    end
  end

  describe '#config_set_args' do
    it 'returns the last two args' do
      c = klass.new('/config set arg1 arg2', nil, nil, nil)
      expect(c.config_set_args).to eq %w(arg1 arg2)
    end
  end

  describe '#is_valid_set_command?' do
    it 'requires the subcommand to be set' do
      c = klass.new('/config wat', nil, nil, nil)
      expect(c.is_valid_set_command?).to eq false
    end

    it 'requires is false if less than 4 arguments' do
      c = klass.new('/config set hello', nil, nil, nil)
      expect(c.is_valid_set_command?).to eq false
    end

    it 'requires all arguments' do
      c = klass.new('/config set hello there', nil, nil, nil)
      expect(c.is_valid_set_command?).to eq true
    end
  end
end
