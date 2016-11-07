module SmsBroker
  module Exceptions
    class NotImplemented < StandardError
      attr_accessor :errors
    end
  end
end
