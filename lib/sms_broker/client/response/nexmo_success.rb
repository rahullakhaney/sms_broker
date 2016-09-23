module SmsBroker
  module Client
    module Response
      class NexmoSuccess < Success
        def initialize(nexmo_response)
          super :nexmo, nexmo_response, serialize(nexmo_response)
        end

        private

        def serialize(response)
          single_response = response['messages'][0]

          {
            to: single_response['to'],
            from: single_response['from'],
            message_id: single_response['message-id'],
            raw: response_to_hash(single_response)
          }
        end

        def response_to_hash(response)
          attributes = %w(
            to from status network message-id client-ref
            remaining-balance message-price
          )

          {}.tap do |hash|
            attributes.each do |attr|
              hash[attr.tr('-', '_').to_sym] = response[attr]
            end
          end
        end
      end
    end
  end
end
