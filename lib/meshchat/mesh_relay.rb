module MeshChat
  class MeshRelay
    # This channel is set by the server
    CHANNEL = 'MeshRelayChannel'
    # TODO: add a way to configure relay nodes
    RELAYS = [
      "ws://mesh-relay-in-us-1.herokuapp.com"
    ]

    def initialize

    end

    # @return [Array] an array of action cable clients
    def setup
      @relays ||= RELAYS.map do |url|
        setup_client_for_url(url)
      end
    end

    def send_message(to, message)
      # Use first relay for now
      # TODO: figure out logic for which relay to send to
      # might have to do with relaying
      @relays.first.perform('chat', to: to, message: message)
    end

    def setup_client_for_url(url)
      path = "#{url}?uid=#{Settings['uid']}"
      client = ActionCableClient.new(path, CHANNEL)

      # don't output anything upon connecting
      client.connected { }

      # but we do want to report errors
      client.errored do |msg|
        Display.alert("an error in the #{path} relay has occurred")
        Display.alert(msg)
      end

      # forward the encrypted messages to our RequestProcessor
      # so that they can be decrypted
      client.received do |message|
        RequestProcessor.process(message[:message])
      end

      client
    end
  end
end
