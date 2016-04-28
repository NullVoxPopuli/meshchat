module MeshChat
  # This file is stupid.
  # But very helpful when debugging problems...
  module Debug
    module_function

    def not_on_local_network(node)
      Display.debug('SENDING: ' + node.alias_name + ' is not on the local network')
    end

    def received_message_from_relay(message, relay_url)
      Display.debug('RECEIVING on RELAY: ' + relay_url)
      Display.debug('RECEIVING on RELAY: ')
      Display.debug(message)
    end

    def sending_message_over_relay(node, message, relay_url)
      Display.debug('SENDING on RELAY: ' + relay_url)
      Display.debug('SENDING on RELAY: ' + node.as_json.to_json)
      Display.debug('SENDING on RELAY: ' + message.class.name)
      Display.debug('SENDING on RELAY: ' + message.inspect)
    end

    def receiving_message(message)
      Display.debug('RECEIVING: ' + message.type)
      Display.debug('RECEIVING: ' + message.sender.to_s)
      Display.debug('RECEIVING: ' + message.message.to_s)
    end


    def sending_message(message)
      Display.debug('SENDING: ' + message.type)
      Display.debug('SENDING: ' + message.sender.to_s)
      Display.debug('SENDING: ' + message.message.to_s)
    end

    def person_not_online(node, message, e)
      Display.debug("#{message.class.name}: Issue connectiong to #{node.alias_name}@#{node.location}")
      Display.debug(e.message)
    end

    def encryption_failed(node)
      Display.info "Public key encryption for #{node.try(:alias_name) || 'unknown'} failed"
    end

    def creating_input_failed(e)
      Display.error e.message
      Display.error e.class.name
      Display.error e.backtrace.join("\n").colorize(:red)
    end

  end
end
