module SmsBroker
  module Client

    class Nexmo < Base

      def initialize(options)
        nexmo_options = options.dup

        auth_options = {
          key:    nexmo_options.delete(:key),
          secret: nexmo_options.delete(:secret)
        }

        @sender_id = nexmo_options.delete(:sender_id)
        @phone_number = nexmo_options.delete(:phone_number)

        super(:nexmo, ::Nexmo::Client.new(auth_options))
      end

      def send_message(message)
        response = client.send_message \
          text: message[:text],
          from: serialize_number(message[:from]),
          to: serialize_number(message[:to])

        if success_response?(response)
          Response::NexmoSuccess.new(response)
        else
          Response::NexmoError.new(response)
        end
      end

      private

      def success_response?(response)
        # just looking for the first message,
        # right now only one message per call
        response['messages'].length > 0 && response['messages'][0]['status'] == '0'
      end

    end

  end
end
