module SmsBroker
  module Client
    module Response
      class TwilioError < Error
        SENDER_ID_NOT_SUPPORTED = '21212'.freeze

        def initialize(twilio_response)
          super :twilio, twilio_response, serialize(twilio_response)
        end

        private

        def serialize(twilio_response)
          if twilio_response.is_a?(::Twilio::REST::RequestError)
            serialize_exeception_errors(twilio_response)
          else
            serialize_response_error(twilio_response)
          end
        end

        def serialize_response_error(response)
          errors = {
            response.error_code.to_s => [response.error_message]
          }

          if response.error_code.to_s == SENDER_ID_NOT_SUPPORTED
            errors['sender_id'] = ['is invalid']
          end

          errors
        end

        def serialize_exeception_errors(exception)
          errors = {
            exception.code.to_s => [exception.message]
          }

          if exception.code.to_s == SENDER_ID_NOT_SUPPORTED
            errors['sender_id'] = ['is invalid']
          end

          errors
        end
      end
    end
  end
end
