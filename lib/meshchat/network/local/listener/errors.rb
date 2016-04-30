module MeshChat
  module Net
    module Listener
      module Errors
        class NotAuthorized < StandardError; end
        class Forbidden < StandardError; end
        class BadRequest < StandardError; end
      end
    end
  end
end
