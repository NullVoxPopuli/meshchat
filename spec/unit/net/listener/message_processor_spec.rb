require 'spec_helper'

describe MeshChat::Net::Listener::MessageProcessor do
  let(:klass){ MeshChat::Net::Listener::MessageProcessor }
  let(:message_dispatcher){ MeshChat::Net::MessageDispatcher.new }
  before(:each) do
    start_fake_relay_server
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
  end


  context 'process' do
    before(:each) do
      key_pair = OpenSSL::PKey::RSA.new(2048)
      @public_key = key_pair.public_key.export
      @private_key = key_pair.export

      @node_me = MeshChat::Node.new(
        alias_name: 'me',
        location_on_network: 'localhost:2008',
        uid: '1233123',
        public_key: @public_key
      )

      key_pair = OpenSSL::PKey::RSA.new(2048)
      @public_key1 = key_pair.public_key.export
      @private_key1 = key_pair.export

      allow(MeshChat::Cipher).to receive(:current_encryptor){ MeshChat::Encryption::AES_RSA}
    end
    context 'throws exceptions' do
      context 'not authorized' do
        it 'cannot be decrypted' do
          MeshChat::Settings[:privatekey] = @private_key1
          message = MeshChat::Message::Ping.new
          raw = MeshChat::Net::Request.new(@node_me, message).payload

          expect{
            klass.process(raw, message_dispatcher: message_dispatcher )
          }.to raise_error MeshChat::Net::Listener::Errors::NotAuthorized
        end
      end

      context 'forbidden' do
        it 'receives a message from a non-existant node' do
          MeshChat::Settings[:privatekey] = @private_key
          message = MeshChat::Message::Ping.new
          raw = MeshChat::Net::Request.new(@node_me, message).payload

          expect{
            klass.process(raw, message_dispatcher: message_dispatcher)
          }.to raise_error MeshChat::Net::Listener::Errors::Forbidden
        end
      end

      context 'bad request' do
        it 'uses an unsupported type' do
          MeshChat::Settings[:privatekey] = @private_key
          message = MeshChat::Message::Ping.new
          message.instance_variable_set('@type', 'unsupported')
          raw = MeshChat::Net::Request.new(@node_me, message).payload

          expect{
            klass.process(raw, message_dispatcher: message_dispatcher)
          }.to raise_error MeshChat::Net::Listener::Errors::BadRequest
        end

      end
    end
  end


  describe '#update_sender_info' do
    it 'dispatches the server list hash' do
      node = MeshChat::Node.new(
        uid: '100',
        alias_name: 'nullvp',
        location_on_network: 'localhost:80',
        public_key: 'wat',
        on_local_network: false
      )

      node.save!

      json = '{
        "type":"chat",
        "message":"gr",
        "client":"Spiced Gracken",
        "client_version":"0.1.2",
        "time_sent":"2015-09-30T13:04:39.019-04:00",
        "sender":{
          "alias":"nvp",
          "location":"10.10.10.10:1010",
          "uid":"100"
        }}'
      data = JSON.parse(json)

      expect(MeshChat::Message::NodeListHash).to receive(:new)
      expect(message_dispatcher).to receive(:send_message)
      expect{
        klass.update_sender_info(data, message_dispatcher: message_dispatcher)
      }.to change(MeshChat::Node.on_local_network, :count).by(1)

      expect(MeshChat::Node.find(node.id).location).to eq '10.10.10.10:1010'
    end

    it 'does not dispatch the server list hash if the message is from an active node' do
      MeshChat::Node.create(
        uid: '100',
        alias_name: 'hi',
        location_on_network: '1.1.1.1:11',
        public_key: 'wat'
      )

      json = '{
        "type":"chat",
        "message":"gr",
        "client":"Spiced Gracken",
        "client_version":"0.1.2",
        "time_sent":"2015-09-30T13:04:39.019-04:00",
        "sender":{
          "alias":"nvp",
          "location":"10.10.10.10:1010",
          "uid":"100"
        }}'
      data = JSON.parse(json)

      expect_any_instance_of(MeshChat::Message::NodeListHash).to_not receive(:render)
      expect(message_dispatcher).to_not receive(:send_message)
      klass.update_sender_info(data, message_dispatcher: message_dispatcher)
    end
  end
end
