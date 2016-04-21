module MeshChat
  module Debug
    module_function

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
