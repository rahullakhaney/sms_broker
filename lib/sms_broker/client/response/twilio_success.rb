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
            raw: {
              to: response.to,
              sid: response.sid,
              uri: response.uri,
              from: response.from,
              body: response.body,
              price: response.price,
              status: response.status,
              price_unit: response.price_unit,
              error_code: response.error_code,
              account_sid: response.account_sid,
              api_version: response.api_version,
              date_created: response.date_created,
              error_message: response.error_message,
              messaging_service_sid: response.messaging_service_sid
            }
          }
        end

      end

    end
  end
end
