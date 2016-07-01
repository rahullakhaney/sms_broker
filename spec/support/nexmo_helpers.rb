require 'rack'

module NexmoHelpers

  # NEXMO CREATE MESSAGE -------------------------------------------------------

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

  def stub_nexmo_create_message_missing_params(to, message)
    request_body = {
      to: to,
      from: nil,
      text: message,
      api_key: ENV['NEXMO_API_KEY'],
      api_secret: ENV['NEXMO_API_SECRET']
    }

    response_body = {
      'message-count' => '1',
      'messages' => [
        {
          'status' => '2',
          'error-text' => 'Missing from param'
        }
      ]
    }

    stub_nexmo_create_message(request_body, response_body)
  end

  def stub_nexmo_create_message_invalid_sender_id_request(sender_id, to, message)
    request_body = {
      to: to,
      from: sender_id,
      text: message,
      api_key: ENV['NEXMO_API_KEY'],
      api_secret: ENV['NEXMO_API_SECRET']
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
      api_key: ENV['NEXMO_API_KEY'],
      api_secret: ENV['NEXMO_API_SECRET']
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

  # NEXMO GET MESSAGE ----------------------------------------------------------

  def stub_nexmo_get_message(message_id, response_body)
    query_string = \
      Rack::Utils.build_query \
        id: message_id,
        api_key: ENV['NEXMO_API_KEY'],
        api_secret: ENV['NEXMO_API_SECRET']

    stub_request(:get, "https://rest.nexmo.com/search/message?#{query_string}")
      .to_return(
        status: 200,
        body: response_body.to_json,
        headers: {
          'Content-Type' => 'application/json'
        }
      )
  end

  def stub_nexmo_get_message_success(message_id)
    response_body = {
      "to" => "1234567890",
      "from" => "1234567890",
      "body" => "Hello[Nexmo DEMO]",
      "type" => "MT",
      "price" => "0.03330000",
      "network" => "23420",
      "latency" => 2234,
      "message-id" => message_id,
      "account-id" => "12345678",
      "date-closed" => "2016-05-03 12:03:56",
      "final-status" => "DELIVRD",
      "date-received" => "2016-05-03 12:03:53"
    }

    stub_nexmo_get_message(message_id, response_body)
  end

end
