module SmsBroker
  module Client
    module Response
      class NexmoVoiceError < Error
        def initialize(nexmo_response)
          super :nexmo, nexmo_response, serialize_error_response(nexmo_response)
        end

        private

        def serialize_error_response(nexmo_response)
          errors = {}.tap do |hash|
            hash[nexmo_response['status']] = nexmo_response['error']
          end

          errors
        end
      end
    end
  end
end
