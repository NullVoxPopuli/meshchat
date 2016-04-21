require 'spec_helper'

describe MeshChat::Net::Listener::MessageProcessor do
  let(:klass){ MeshChat::Net::Listener::MessageProcessor }


  before(:each) do
    mock_settings_objects
  end

  describe '#update_sender_info' do
    it 'dispatches the server list hash' do
      node = MeshChat::Node.new(
        uid: '100',
        alias_name: 'nullvp',
        location: 'localhost:80',
        public_key: 'wat',
        online: false
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
      expect(MeshChat::Net::Client).to receive(:send)
      expect{
        klass.update_sender_info(data)
      }.to change(MeshChat::Node.online, :count).by(1)

      expect(MeshChat::Node.find(node.id).location).to eq '10.10.10.10:1010'
    end

    it 'does not dispatch the server list hash if the message is from an active node' do
      MeshChat::Node.create(
        uid: '100',
        alias_name: 'hi',
        location: '1.1.1.1:11',
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
      expect(MeshChat::Net::Client).to_not receive(:send)
      klass.update_sender_info(data)
    end
  end
end
