require 'sms_broker/message_sender'
require 'sms_broker/client/base'
require 'sms_broker/client/nexmo'
require 'sms_broker/client/twilio'
require 'sms_broker/exceptions/invalid_service'

module SmsBroker
  CLIENTS = {
    nexmo: Client::Nexmo,
    twilio: Client::Twilio
  }.freeze

  class Service
    def self.get(name)
      options = service_configuration(name)

      result = Service.validate(name, options)

      unless result.valid?
        raise Exceptions::InvalidService, name.to_sym => result.errors
      end

      new CLIENTS[name.to_sym].new(options)
    end

    def self.service_configuration(name)
      SmsBroker.configuration[:services_setups][name.to_sym]
    end

    def self.validate(name, options)
      Setup.service_validation_schemas[name.to_sym].validate(options)
    end

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def message(message)
      MessageSender.new(client).message(message)
    end
  end
end
