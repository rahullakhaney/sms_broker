require 'nexmo'
require 'compel'
require 'twilio-ruby'
require 'sms_broker/client/response/error'
require 'sms_broker/client/response/success'
require 'sms_broker/configuration'
require 'sms_broker/service'

module SmsBroker
  extend Configuration

  def service(name = default_service)
    Service.get(name)
  end

  def message(body)
    service.message(body)
  end

  extend self
end
