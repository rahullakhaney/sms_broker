module SmsBroker
  module Client
    module Response
      class VoiceSuccess
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

        def call_id
          serialized[:call_id]
        end
      end
    end
  end
end

require 'sms_broker/client/response/nexmo_voice_success'
