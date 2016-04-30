# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Command::Irb do
  let (:klass) { Meshchat::Command::Irb }
  let(:message_dispatcher) { Meshchat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message) {}
  end

  describe '#handle' do
    it 'alerts the user' do
      # don't actually shut down...
      expect(Meshchat::Models::Entry).to receive(:first)
      c = klass.new('/c Node.first', message_dispatcher)
      c.handle
    end
  end
end
