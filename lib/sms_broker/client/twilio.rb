module SmsBroker
  module Client
    class Twilio < Base
      def initialize(options)
        client = \
          ::Twilio::REST::Client.new(options[:account_sid], options[:auth_token])

        super :Twilio, client, options
      end

      def send_message(message)
        begin
          response = client.messages.create \
            body: message[:text],
            from: message[:from],
            to: serialize_to_number(message[:to])

          if success_response?(response)
            Response::TwilioSuccess.new(response)
          else
            Response::TwilioError.new(response)
          end

        rescue ::Twilio::REST::RequestError => exception
          Response::TwilioError.new(exception)
        end
      end

      private

      def success_response?(response)
        !['undelivered', 'failed'].include?(response.status)
      end
    end
  end
end
