# frozen_string_literal: true
require 'socket'
require 'open-uri'

module Meshchat
  module Ui
    module Command
      class Bind < Command::Base
        def self.description
          'helper for choosing what ip address to use for yourself'
        end

        def handle
          options = ip_addresses
          option_numbers = []
          Display.success 'Choose an ip:'
          options.each_with_index do |ip, index|
            Display.info "#{index}: #{ip}"
            option_numbers << index
          end

          selected = gets

          if option_numbers.include?(selected.to_i)
            Display.success Settings.set('ip', with: options[selected.to_i])
          else
            Display.alert 'Invalid selection'
            handle # repeat
          end
        end

        def ip_addresses
          local = Socket.getifaddrs.map { |i| i.addr.ip_address if i.addr.ipv4? }.compact
          # get public
          begin
            remote_ip = open('http://whatismyip.akamai.com').read
            local << remote_ip
          rescue => e
            Display.fatal e.message
            Display.alert 'public ip lookup failed'
          end
          local
        end
      end
    end
  end
end
