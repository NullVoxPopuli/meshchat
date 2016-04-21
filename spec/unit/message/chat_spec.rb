require 'spec_helper'

describe MeshChat::Message::Chat do
  let(:klass) { MeshChat::Message::Chat }

  context 'instantiation' do

    before(:each) do
      mock_settings_objects
    end
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end

  describe '#display' do
    before(:each) do
      payload = {
        'type' => 'chat',
         'message' => @message = 'message',
         'client' => MeshChat::APP_CONFIG[:client_name],
         'client_version' => MeshChat::VERSION,
         'time_sent' => @time = Time.now, # not yet sent
         'sender' => {
           'alias' => @sender = 'name_of_sender',
           'location' => 'location',
           'uid' => 'uid'
         }
      }
      @msg = klass.new(payload: payload)
    end

    it 'has the time' do
      format_of_time = @time.strftime('%e/%m/%y %H:%I:%M')
      expect(@msg.display).to include(format_of_time)
    end

    it 'has the sender' do
      expect(@msg.display).to include(@sender)
    end

    it 'has the message' do
      expect(@msg.display).to include(@message)
    end
  end
end
