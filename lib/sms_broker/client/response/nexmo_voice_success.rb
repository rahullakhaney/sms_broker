module SmsBroker
  module Client
    module Response
      class NexmoVoiceSuccess < VoiceSuccess
        def initialize(nexmo_response)
          super :nexmo, nexmo_response, serialize(nexmo_response)
        end

        private

        def serialize(response)
          {
            call_id: response['call_id'],
            to: response['to'],
            raw: response_to_hash(response)
          }
        end

        def response_to_hash(response)
          attributes = %w(
            call_id to status error_text
          )

          {}.tap do |hash|
            attributes.each do |attr|
              hash[attr.to_sym] = response[attr]
            end
          end
        end
      end
    end
  end
end
