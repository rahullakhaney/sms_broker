module SmsBroker
  module Client
    module Response

      class NexmoError < Error

        SENDER_ID_NOT_SUPPORTED = '15'

        def initialize(nexmo_response)
          super :nexmo, nexmo_response, serialize_error_response(nexmo_response)
        end

        private

        def serialize_error_response(nexmo_response)
          errors = {}.tap do |hash|
            nexmo_response['messages'].each do |message|
              hash[message['status']] = [message['error-text']]
            end

            hash
          end

          if errors.keys.include?(SENDER_ID_NOT_SUPPORTED)
            errors['sender_id'] = ['is invalid']
          end

          errors
        end

      end

    end
  end
end
