# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Incoming::MessageProcessor do
  let(:klass) { Meshchat::Network::Incoming::MessageProcessor }
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  let(:message_processor) { klass.new(message_dispatcher: message_dispatcher) }
  before(:each) do
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message)
    # allow_any_instance_of(Meshchat::Network::Dispatcher).to receive(:send_message)
  end

  context 'process' do
    before(:each) do
      key_pair = OpenSSL::PKey::RSA.new(2048)
      @public_key = key_pair.public_key.export
      @private_key = key_pair.export

      @node_me = Meshchat::Node.new(
        alias_name: 'me',
        location_on_network: 'localhost:2008',
        uid: '1233123',
        public_key: @public_key
      )

      key_pair = OpenSSL::PKey::RSA.new(2048)
      @public_key1 = key_pair.public_key.export
      @private_key1 = key_pair.export

      allow(Meshchat::Encryption).to receive(:current_encryptor) { Meshchat::Encryption::AES_RSA }
    end
    context 'throws exceptions' do
      context 'not authorized' do
        it 'cannot be decrypted' do
          Meshchat::APP_CONFIG.user[:privatekey] = @private_key1
          message = Meshchat::Network::Message::Ping.new
          raw = message.encrypt_for(@node_me)

          expect do
            message_processor.process(raw)
          end.to raise_error Meshchat::Network::Errors::NotAuthorized
        end
      end

      context 'forbidden' do
        it 'receives a message from a non-existant node' do
          Meshchat::APP_CONFIG.user[:privatekey] = @private_key
          message = Meshchat::Network::Message::Ping.new
          raw = message.encrypt_for(@node_me)

          expect do
            message_processor.process(raw)
          end.to raise_error Meshchat::Network::Errors::Forbidden
        end
      end

      context 'bad request' do
        it 'uses an unsupported type' do
          Meshchat::APP_CONFIG.user[:privatekey] = @private_key
          message = Meshchat::Network::Message::Ping.new
          message.instance_variable_set('@type', 'unsupported')
          raw = message.encrypt_for(@node_me)

          expect do
            message_processor.process(raw)
          end.to raise_error Meshchat::Network::Errors::MessageTypeNotRecognized
        end
      end
    end
  end

  describe '#update_sender_info' do
    it 'dispatches the server list hash' do
      node = Meshchat::Node.new(
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

      expect(Meshchat::Network::Message::NodeListHash).to receive(:new)
      expect(message_dispatcher).to receive(:send_message)
      expect do
        message_processor.update_sender_info(data)
      end.to change(Meshchat::Node.on_local_network, :count).by(1)

      expect(Meshchat::Node.find(node.id).location).to eq '10.10.10.10:1010'
    end

    it 'does not dispatch the server list hash if the message is from an active node' do
      Meshchat::Node.create(
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

      expect_any_instance_of(Meshchat::Network::Message::NodeListHash).to_not receive(:render)
      expect(message_dispatcher).to_not receive(:send_message)
      message_processor.update_sender_info(data)
    end
  end
end
