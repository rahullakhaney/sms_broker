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
            raw: {
              to: single_response['to'],
              from: single_response['from'],
              status: single_response['status'],
              network: single_response['network'],
              message_id: single_response['message-id'],
              client_ref: single_response['client-ref'],
              remaining_balance: single_response['remaining-balance'],
              message_price: single_response['message-price']
            }
          }
        end

      end

    end
  end
end
