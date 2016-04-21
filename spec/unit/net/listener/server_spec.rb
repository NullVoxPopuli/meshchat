
require 'spec_helper'

describe MeshChat::Net::Listener::Server do
  let(:klass) { MeshChat::Net::Listener::Server }

  before(:each) do
    pending 'server logic extraction'
    mock_settings_objects

    key_pair = OpenSSL::PKey::RSA.new(2048)
    @public_key = key_pair.public_key.export
    @private_key = key_pair.export

    @node_me = MeshChat::Node.new(
      alias_name: 'me',
      location: 'localhost:2008',
      uid: '1233123',
      public_key: @public_key
    )

    key_pair = OpenSSL::PKey::RSA.new(2048)
    @public_key1 = key_pair.public_key.export
    @private_key1 = key_pair.export

    @server = klass.new
    allow(@server).to receive(:status_of) do |status|
      status
    end


    allow(MeshChat::Cipher).to receive(:current_encryptor){ MeshChat::Encryption::AES_RSA}
  end

  context 'process' do
    context 'throws exceptions' do
      context 'not authorized' do
        it 'cannot be decrypted' do
          MeshChat::Settings[:privatekey] = @private_key1
          message = MeshChat::Message::Ping.new
          raw = MeshChat::Net::Client.payload_for(@node_me, message)[:message]

          expect(@server.process(raw)).to eq MeshChat::Net::Listener::Server::NOT_AUTHORIZED
        end
      end

      context 'forbidden' do
        it 'receives a message from a non-existant node' do
          MeshChat::Settings[:privatekey] = @private_key
          message = MeshChat::Message::Ping.new
          raw = MeshChat::Net::Client.payload_for(@node_me, message)[:message]

          expect(@server.process(raw)).to eq MeshChat::Net::Listener::Server::FORBIDDEN
        end
      end

      context 'bad request' do
        it 'uses an unsupported type' do
          MeshChat::Settings[:privatekey] = @private_key
          message = MeshChat::Message::Ping.new
          message.instance_variable_set('@type', 'unsupported')
          raw = MeshChat::Net::Client.payload_for(@node_me, message)[:message]

          expect(@server.process(raw)).to eq MeshChat::Net::Listener::Server::BAD_REQUEST
        end

      end
    end
  end
end
