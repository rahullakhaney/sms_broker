module SmsBroker
  module Client
    module Response
      class Error
        attr_reader :service,
                    :response,
                    :serialized

        def initialize(service, response, serialized = {})
          @service = service
          @response = response
          @serialized = { errors: serialized }
        end

        def success?
          false
        end

        def invalid_sender_id?
          (@serialized[:errors]['sender_id'] || []).include?('is invalid')
        end
      end
    end
  end
end

require 'sms_broker/client/response/nexmo_error'
require 'sms_broker/client/response/twilio_error'
require 'sms_broker/client/response/nexmo_voice_error'
