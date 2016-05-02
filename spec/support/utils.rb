# frozen_string_literal: true
def mock_settings_objects
  delete_test_files

  s = Meshchat::Configuration::Settings.new
  s.instance_variable_set('@filename', 'test-settings')
  s._hash = Meshchat::Configuration::Settings::DEFAULT_SETTINGS.dup
  s.save

  Meshchat::APP_CONFIG[:user] = s
  Meshchat::APP_CONFIG.user['port'] = 0
  allow(Meshchat::Encryption).to receive(:current_encryptor){
    Meshchat::Encryption::Passthrough
  }
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
  Meshchat::Network::Dispatcher.const_set(:RELAYS, [
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

  Meshchat::Configuration::Database.create_database

  # just to be sure
  Meshchat::Node.destroy_all
end
