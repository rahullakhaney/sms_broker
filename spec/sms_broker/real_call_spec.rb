describe SmsBroker do
  context 'SmsBroker' do
    let(:text_message) { 'Hello World' }

    context 'Valid real calls' do
      before(:all) do
        unless ENV['REAL_PHONE_NUMBER']
          skip "REAL_PHONE_NUMBER env var is required to run this spec"
        end

        WebMock.allow_net_connect!

        SmsBroker.clear_setup

        SmsBroker.setup do |config|
          config.services ['nexmo', 'twilio']

          config.default_service 'nexmo'

          config.nexmo_setup \
            key: ENV['NEXMO_LIVE_API_KEY'],
            sender_id: ENV['NEXMO_LIVE_SENDER_ID'],
            secret: ENV['NEXMO_LIVE_API_SECRET'],
            phone_number: ENV['NEXMO_LIVE_PHONE_NUMBER']

          config.twilio_setup \
            sender_id: ENV['TWILIO_LIVE_SENDER_ID'],
            auth_token: ENV['TWILIO_LIVE_AUTH_TOKEN'],
            account_sid: ENV['TWILIO_LIVE_ACCOUNT_SID'],
            phone_number: ENV['TWILIO_LIVE_PHONE_NUMBER']
        end
      end

      after(:all) do
        WebMock.disable_net_connect!
      end

      context 'Nexmo' do
        it "should successfuly send message" do
          message = \
            SmsBroker.service(:nexmo).message(text_message).to(ENV['REAL_PHONE_NUMBER'])

          expect(message.deliver.success?).to eq true
        end
      end

      context 'Twillio' do
        it "should successfuly send message" do
          message = \
            SmsBroker.service(:twilio).message(text_message).to(ENV['REAL_PHONE_NUMBER'])
          expect(message.deliver.success?).to eq true
        end
      end
    end
  end
end
