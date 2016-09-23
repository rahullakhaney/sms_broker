require 'sms_broker/setup'
require 'sms_broker/exceptions/invalid_setup'

module SmsBroker
  module Configuration
    extend self

    @configuration = nil

    def default_service
      configuration[:default_service]
    end

    def clear_setup
      @configuration = nil
    end

    def configuration
      exception = \
        Exceptions::InvalidSetup.new('setup does not exists')

      @configuration || (raise exception)
    end

    def setup
      setup = Setup.new
      yield setup if block_given?

      @configuration = setup.options

      setup
    end

    def setup!
      setup = Setup.new
      yield setup if block_given?

      unless setup.valid?
        exception = \
          Exceptions::InvalidSetup.new("setup is invalid, #{setup.errors}")

        exception.errors = setup.errors

        raise exception
      end

      @configuration = setup.options

      setup
    end
  end
end
