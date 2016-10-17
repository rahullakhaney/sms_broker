module SmsBroker
  module Client
    class Nexmo < Base
      def initialize(options)
        client = \
          ::Nexmo::Client.new(key: options[:key], secret: options[:secret])

        super :nexmo, client, options
      end

      def send_message(message)
        response = client.send_message \
          text: message[:text],
          from: message[:from],
          to: serialize_to_number(message[:to])

        if success_response?(response)
          Response::NexmoSuccess.new(response)
        else
          Response::NexmoError.new(response)
        end
      end

      def send_voice_message(message)
        response = client.initiate_tts_call \
          text: message[:text],
          from:  message[:from],
          to: serialize_to_number(message[:to]),
          lg: message[:lang]

        if voice_success_response?(response)
          Response::NexmoVoiceSuccess.new(response)
        else
          Response::NexmoVoiceError.new(response)
        end
      end

      private

      def success_response?(response)
        # just looking for the first message,
        # right now only one message per call
        !response['messages'].empty? && response['messages'][0]['status'] == '0'
      end

      def voice_success_response?(response)
        response['status'] == '0'
      end
    end
  end
end
