# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Ui::CLI do
  let(:klass) { Meshchat::Ui::CLI }

  before(:each) do
    mock_settings_objects
  end

  context 'initialize' do
    it 'does not error' do
      expect do
        klass.new(nil, nil, nil)
      end.to_not raise_error
    end
  end
end
