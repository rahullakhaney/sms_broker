require 'nexmo'
require 'compel'
require 'twilio-ruby'
require 'sms_broker/client/response/error'
require 'sms_broker/client/response/success'
require 'sms_broker/client/response/voice_success'
require 'sms_broker/configuration'
require 'sms_broker/service'

module SmsBroker
  extend Configuration

  module_function

  def service(name = default_service)
    Service.get(name)
  end

  def message(body)
    service.message(body)
  end

  def voice_message(body)
    service.voice_message(body)
  end
end
