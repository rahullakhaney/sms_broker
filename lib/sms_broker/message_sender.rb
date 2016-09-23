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

      if should_try_with_phone_number?(response)
        return client.send_message(build_message(:phone_number))
      end

      response
    end

    def valid?
      schema = {
        message: Compel.string.required.max_length(140),
        to: Compel.string.required
      }

      object = {
        message: @message_text,
        to: @message_to
      }

      result = Compel.hash.keys(schema).validate(object)

      @errors = result.errors

      result.valid?
    end

    private

    def build_message(from = :sender_id)
      {
        text: @message_text,
        from: get_sender(from),
        to:   @message_to
      }
    end

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
  end
end
