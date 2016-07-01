module SmsBroker

  class MessageSender

    attr_reader :client,
                :errors

    def initialize(client)
      @client = client
    end

    def to(number)
      @message_to = number

      self
    end

    def message(text)
      @message_text = text

      self
    end

    def deliver
      unless valid?
        return Client::Response::Error.new(client.name, errors, errors)
      end

      response = client.send_message(build_message)

      if should_try_again_with_phone_number?(response)
        return client.send_message(build_message(:phone_number))
      end

      response
    end

    private

    def build_message(from = :sender_id)
      sender = \
        if client.sender_id && from == :sender_id
          client.sender_id
        else
          client.phone_number
        end

      {
        text: @message_text,
        from: sender,
        to:   @message_to
      }
    end

    def should_try_again_with_phone_number?(response)
      response.is_a?(Client::Response::Error) &&
        response.invalid_sender_id? &&
          !!client.sender_id
    end

    def valid?
      schema = {
        message: Compel.string.required.max_length(140),
        to: Compel.string.required
      }

      result = \
        Compel.hash.keys(schema).validate(message: @message_text, to: @message_to)

      @errors = result.errors

      result.valid?
    end

  end

end
