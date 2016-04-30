# frozen_string_literal: true
def mock_settings_objects
  delete_test_files
  setup_database

  config = Meshchat::Configuration.new(
    display: MeshchatStub::Display::Null::UI
  )

  allow(Meshchat::Cipher).to receive(:current_encryptor){
    Meshchat::Encryption::Passthrough
  }

  allow_any_instance_of(Meshchat::Config::Settings).to receive(:filename) { 'test-settings' }
  s = Meshchat::Config::Settings.new
  allow(Meshchat::Config::Settings).to receive(:instance) { s }
end

def delete_test_files
  File.delete('test.sqlite3') if File.exist?('test.sqlite3')
  File.delete('test-hashfile') if File.exist?('test-hashfile')
  File.delete('test-settings') if File.exist?('test-settings')
  File.delete('test-activeserverlist') if File.exist?('test-activeserverlist')
rescue => e
  # I wonder if this would be a problem?
  ap e.message
end

require 'em-websocket'
def start_fake_relay_server(options = {})
  Meshchat::Net::MessageDispatcher.const_set(:RELAYS, [
                                               'ws://0.0.0.0:12345'
                                             ])
  Thread.new do
    EM.run do
      EM::WebSocket.run({ host: '0.0.0.0', port: 12_345 }.merge(options)) do |ws|
        yield ws if block_given?
      end
    end
  end
end

def setup_database
  # this method differs from the one defined on meshchat, in that
  # in destroys all nodes and uses an in-memory db

  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ':memory:'
  )

  Meshchat::Database.create_database

  # just to be sure
  Meshchat::Models::Entry.destroy_all
end
