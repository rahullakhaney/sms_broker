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

  def stub_nexmo_create_message_invalid_sender_id_request(sender_id, to, message)
    request_body = {
      to: to,
      from: sender_id,
      text: message,
      api_key: 'api_key',
      api_secret: 'api_secret'
    }

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
    request_body = {
      to: to,
      from: from,
      text: message,
      api_key: 'invalid',
      api_secret: 'invalid'
    }

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
    request_body = {
      to: to,
      from: from,
      text: message,
      api_key: 'api_key',
      api_secret: 'api_secret'
    }

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
    request_body = {
      to: to,
      from: from,
      text: message,
      api_key: 'api_key',
      api_secret: 'api_secret'
    }

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
end
