Sms broker
==========================

### Usage

```ruby
SmsBroker.setup do |config|
  config.services ['nexmo', 'twilio']

  config.default_service 'nexmo'

  config.nexmo_setup \
    key: 'NEXMO_API_KEY',
    secret: 'NEXMO_API_SECRET',
    sender_id: 'NEXMO_SENDER_ID',
    phone_number: 'NEXMO_PHONE_NUMBER'

  config.twilio_setup \
    auth_token: 'TWILIO_AUTH_TOKEN',
    account_sid: 'TWILIO_ACCOUNT_SID',
    sender_id: 'TWILIO_SENDER_ID',
    phone_number: 'TWILIO_PHONE_NUMBER'
end
```

#### Basic usage
```ruby
message = SmsBroker.message('Get paid doing small tasks!').to('441234567890')

if message.valid?
  response = message.deliver

  # response.success?
  # response.serialized
end
```

#### Specifying the provider
```ruby
SmsBroker.service(:twilio).message('Get paid doing small tasks!').to('441234567890')
```

###Installation

Add this line to your application's Gemfile:

    gem 'sms_broker'

And then execute:

    $ bundle

### Get in touch

If you have any questions, write an issue or get in touch dev@streetbees.com

