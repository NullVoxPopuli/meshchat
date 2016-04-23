def mock_settings_objects
  delete_test_files
  setup_database

  config = MeshChat::Configuration.new(
    display: MeshChatStub::Display::Null::UI
  )
  
  allow(MeshChat::Cipher).to receive(:current_encryptor){
      MeshChat::Encryption::Passthrough
  }

  allow_any_instance_of(MeshChat::Config::Settings).to receive(:filename) { 'test-settings' }
  s = MeshChat::Config::Settings.new
  allow(MeshChat::Config::Settings).to receive(:instance) { s }
end

def delete_test_files
  begin
    File.delete('test.sqlite3') if File.exist?('test.sqlite3')
    File.delete('test-hashfile') if File.exist?('test-hashfile')
    File.delete('test-settings') if File.exist?('test-settings')
    File.delete('test-activeserverlist') if File.exist?('test-activeserverlist')
  rescue => e
    # I wonder if this would be a problem?
    ap e.message
  end
end

require 'em-websocket'
def start_fake_relay_server(options = {})
  MeshChat::Net::MessageDispatcher.const_set(:RELAYS, [
    "ws://0.0.0.0:12345"
  ])
  Thread.new do
    EM.run do
      EM::WebSocket.run({:host => "0.0.0.0", :port => 12345}.merge(options)) { |ws|
        yield ws if block_given?
      }
    end
  end
end

def setup_database
  # this method differs from the one defined on meshchat, in that
  # in destroys all nodes and uses an in-memory db

  ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database  => ':memory:'
  )

  MeshChat::Database.create_database

  # just to be sure
  MeshChat::Models::Entry.destroy_all
end
