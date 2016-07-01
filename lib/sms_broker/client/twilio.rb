module SmsBroker
  module Client

    class Twilio < Base

      def initialize(options)
        twilio_options = options.dup

        auth_options = {
          account_sid: twilio_options.delete(:account_sid),
          auth_token:  twilio_options.delete(:auth_token)
        }

        @sender_id = twilio_options.delete(:sender_id)
        @phone_number = twilio_options.delete(:phone_number)

        super \
          :twilio,
          ::Twilio::REST::Client.new(auth_options[:account_sid], auth_options[:auth_token])
      end

      def send_message(message)
        begin
          response = client.messages.create \
            body: message[:text],
            from: serialize_number(message[:from]),
            to: serialize_number(message[:to])

          if success_response?(response)
            Response::TwilioError.new(response)
          else
            Response::TwilioSuccess.new(response)
          end

        rescue ::Twilio::REST::RequestError => exception
          Response::TwilioError.new(exception)
        end
      end

      private

      def success_response?(response)
        ['undelivered', 'failed'].include?(response.status)
      end

    end

  end
end
