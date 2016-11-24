module SmsBroker
  class VoiceMessageSender
    attr_reader :client,
                :errors,
                :voice_message_text

    def initialize(client)
      @client = client
    end

    def to(number)
      @voice_message_to = number

      self
    end

    def message(text)
      @voice_message_text = text

      self
    end

    def with(options)
      @voice_message_options = options

      self
    end

    def deliver
      unless valid?
        return Client::Response::Error.new(client.name, errors, errors)
      end

      response = client.send_voice_message(build_message)

      if should_try_with_phone_number?(response)
        return client.send_voice_message(build_message(:phone_number))
      end

      response
    end

    def valid?
      options = @voice_message_options || {}

      schema = {
        message: Compel.string.required.max_length(140),
        to: Compel.string.required,
        lang: Compel.string,
        rate: Compel.integer,
        repeat: Compel.integer
      }

      object = {
        message: @voice_message_text,
        to: @voice_message_to,
        lang: options[:lang],
        rate: options[:rate],
        repeat: options[:repeat]
      }

      result = Compel.hash.keys(schema).validate(object)

      @errors = result.errors

      result.valid?
    end

    def build_message(from = :sender_id)
      client.is_a?(SmsBroker::Client::Nexmo) && tag_message

      {
        text: @voice_message_text,
        from: get_sender(from),
        to:   @voice_message_to
      }.merge!(@voice_message_options || {})
    end

    private

    def get_sender(from)
      if client.sender_id && from == :sender_id
        client.sender_id
      else
        return client.phone_number if client.phone_number.start_with?('+')

        "+#{client.phone_number}"
      end
    end

    def should_try_with_phone_number?(response)
      response.is_a?(Client::Response::Error) &&
        response.invalid_sender_id? &&
        client.sender_id
    end

    def tag_message
      return unless @voice_message_options

      @voice_message_options[:rate]   && inject_rate
      @voice_message_options[:repeat] && inject_repeat
    end

    def inject_rate
      rate = @voice_message_options[:rate]
      @voice_message_text = \
        "<prosody rate='#{rate}%'>" + @voice_message_text + '</prosody>'
    end

    def inject_repeat
      @voice_message_text += "<break time='1s'/>"
      @voice_message_text *= @voice_message_options[:repeat]
    end
  end
end
