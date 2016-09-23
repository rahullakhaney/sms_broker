module SmsBroker
  module Client
    module Response
      class Success
        attr_reader :raw,
                    :service,
                    :serialized

        def initialize(service, response, serialized)
          @raw = response
          @service = service
          @serialized = serialized
        end

        def success?
          true
        end

        def to
          serialized[:to]
        end

        def from
          serialized[:from]
        end

        def message_id
          serialized[:message_id]
        end
      end
    end
  end
end

require 'sms_broker/client/response/nexmo_success'
require 'sms_broker/client/response/twilio_success'
