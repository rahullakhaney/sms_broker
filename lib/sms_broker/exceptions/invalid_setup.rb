module SmsBroker
  module Exceptions
    class InvalidSetup < StandardError
      attr_accessor :errors
    end
  end
end
