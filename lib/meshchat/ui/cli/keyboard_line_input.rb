module MeshChat
  class CLI
    class KeyboardLineInput < Base
      include EM::Protocols::LineText2

      def receive_line(data)
        _input_receiver.create_input(data)
      end
    end
  end
end
