require 'rack'

module NexmoHelpers
  def stub_nexmo_create_message(request_body, response_body)
    stub_request(:post, 'https://rest.nexmo.com/sms/json')
      .with(body: request_body)
      .to_return(
        status: 200,
        body: response_body.to_json,
        headers: {
          'Content-Type' => 'application/json'
        }
      )
  end

  def stub_nexmo_create_voice_message(request_body, response_body)
    stub_request(:post, 'https://api.nexmo.com/tts/json')
      .with(body: request_body)
      .to_return(
        status: 200,
        body: response_body.to_json,
        headers: {
          'Content-Type' => 'application/json'
        }
      )
  end

  def build_request_body(from, to, message)
    {
      to: to,
      from: from,
      text: message,
      api_key: 'api_key',
      api_secret: 'api_secret'
    }
  end

  def build_voice_request_body(from, to, message)
    #[RRAMOS] extend this to the additional_parameters
    {
      to: to,
      from: from,
      text: message,
      api_key: 'api_key',
      api_secret: 'api_secret'
    }
  end

  def stub_nexmo_create_message_invalid_sender_id_request(sender_id, to, message)
    request_body = build_request_body(sender_id, to, message)

    response_body = {
      'message-count' => '1',
      'messages' => [
        {
          'status' => '15',
          'error-text' => 'Invalid sender address'
        }
      ]
    }

    stub_nexmo_create_message(request_body, response_body)
  end

  def stub_nexmo_create_message_invalid_credentials(from, to, message)
    request_body = build_request_body(from, to, message)
    request_body.merge! \
      api_key: 'invalid',
      api_secret: 'invalid'

    response_body = {
      'message-count' => '1',
      'messages' => [
        {
          'status' => '4',
          'error-text' => 'Bad Credentials'
        }
      ]
    }

    stub_nexmo_create_message(request_body, response_body)
  end

  def stub_nexmo_create_message_success(from, to, message)
    request_body = build_request_body(from, to, message)

    response_body = {
      'message-count': '1',
      'messages': [
        {
          'remaining-balance': '1.96670000',
          'message-price': '0.03330000',
          'message-id': '02000000D48B0A21',
          'network': '23420',
          'status': '0',
          'from': from,
          'to': to
        }
      ]
    }

    stub_nexmo_create_message(request_body, response_body)
  end

  def stub_nexmo_create_message_unknown_error(from, to, message)
    request_body = build_request_body(from, to, message)

    response_body = {
      'message-count' => '1',
      'messages' => [
        {
          'status' => '1',
          'error-text' => 'Unknown'
        }
      ]
    }

    stub_nexmo_create_message(request_body, response_body)
  end

  def stub_nexmo_create_voice_message_success(from, to, message)
    request_body = build_voice_request_body(from, to, message)

    response_body = {
      'call_id': '1',
      'to': to,
      'status': '0',
      'error_text': ''
    }

    stub_nexmo_create_voice_message(request_body, response_body)
  end

  def stub_nexmo_create_voice_message_invalid_credentials(from, to, message)
    request_body = build_voice_request_body(from, to, message)
    request_body.merge! \
      api_key: 'invalid',
      api_secret: 'invalid'

    response_body = {
      'call_id': '1',
      'to': to,
      'status': '4',
      'error_text': 'Invalid credentials'
    }

    stub_nexmo_create_voice_message(request_body, response_body)
  end
end
