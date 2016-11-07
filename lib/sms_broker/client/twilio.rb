module SmsBroker
  module Client
    class Twilio < Base
      def initialize(options)
        client = ::Twilio::REST::Client.new(
          options[:account_sid],
          options[:auth_token]
        )

        super :Twilio, client, options
      end

      def send_message(message)
        response = client.messages.create \
          body: message[:text],
          from: message[:from],
          to: serialize_to_number(message[:to])

        return Response::TwilioSuccess.new(response) \
          if success_response?(response)

        Response::TwilioError.new(response)
      rescue ::Twilio::REST::RequestError => exception
        Response::TwilioError.new(exception)
      end

      def send_voice_message(message)
        # Not implemented yet
        raise SmsBroker::Exceptions::InvalidService
      end

      private

      def success_response?(response)
        !%w(undelivered failed).include?(response.status)
      end
    end
  end
end
