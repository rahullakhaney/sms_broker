module SmsBroker
  module Client
    module Response
      class TwilioSuccess < Success
        def initialize(twilio_response)
          super :twilio, twilio_response, serialize(twilio_response)
        end

        private

        def serialize(response)
          {
            to: response.to,
            from: response.from,
            message_id: response.sid,
            raw: response_to_hash(response)
          }
        end

        def response_to_hash(response)
          attributes = %i(
            to sid uri from body price status price_unit error_code
            account_sid api_version date_created error_message
            messaging_service_sid
          )

          {}.tap do |hash|
            attributes.each do |attr|
              hash[attr] = response.send(attr)
            end
          end
        end
      end
    end
  end
end
