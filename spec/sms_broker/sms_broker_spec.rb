describe SmsBroker do

  context 'SmsBroker' do

    let(:text_message) { 'Hello World' }

    context 'Invalid data when trying to deliver' do

      before(:all) do
        SmsBroker.clear_setup

        SmsBroker.setup do |config|
          config.services ['twilio']

          config.default_service 'twilio'

          config.twilio_setup \
            phone_number: '15005550001',
            account_sid: ENV['TWILIO_ACCOUNT_SID'],
            auth_token: ENV['TWILIO_AUTH_TOKEN']
        end
      end

      it 'should return error for missing number' do
        response = SmsBroker.service.message(text_message).to(nil).deliver

        expect(response.success?).to eq(false)
        expect(response.serialized[:to]).to include("is required")
      end

      it 'should return error for missing message' do
        response = SmsBroker.service.message(nil).to(nil).deliver

        expect(response.success?).to eq(false)
        expect(response.serialized[:message]).to include("is required")
      end

      it 'should return error for invalid message' do
        message_160 = "Lorem Ipsum is simply dummy text of the printing and " \
                      "typesetting industry. Lorem Ipsum has been the " \
                      "industry's standard dummy text ever since the 1500s, when an"

        response = \
          SmsBroker.service.message(message_160).to('44123457891').deliver

        expect(response.success?).to eq(false)
        expect(response.serialized[:message]).to \
          include("cannot have length greater than 140")
      end

    end

    context 'Invalid setup when trying to deliver' do

      before(:all) do
        SmsBroker.clear_setup

        @setu = SmsBroker.setup do |config|
          config.services ['nexmo']

          config.default_service 'nexmo'

          config.nexmo_setup \
            key: ENV['NEXMO_API_KEY'],
            sender_id: ENV['NEXMO_SENDER_ID'],
            phone_number: ENV['NEXMO_PHONE_NUMBER']
            # secret: ENV['NEXMO_API_SECRET']
        end
      end

      it 'should return error for missing number' do
        expect {
          SmsBroker.service.message(text_message).to('44123457891').deliver
        }.to raise_error SmsBroker::Exceptions::InvalidService
      end

    end

    context 'Valid real calls' do

      before(:all) do
        SmsBroker.clear_setup

        SmsBroker.setup do |config|
          config.services ['nexmo', 'twilio']

          config.default_service 'nexmo'

          config.nexmo_setup \
            key: ENV['NEXMO_API_KEY'],
            secret: ENV['NEXMO_API_SECRET'],
            sender_id: ENV['NEXMO_SENDER_ID'],
            phone_number: ENV['NEXMO_PHONE_NUMBER']

          config.twilio_setup \
            sender_id: ENV['TWILIO_LIVE_SENDER_ID'],
            auth_token: ENV['TWILIO_LIVE_AUTH_TOKEN'],
            account_sid: ENV['TWILIO_LIVE_ACCOUNT_SID'],
            phone_number: ENV['TWILIO_LIVE_PHONE_NUMBER']
        end
      end

      before(:all) do
        unless ENV['REAL_PHONE_NUMBER']
          skip "REAL_PHONE_NUMBER env var is required to run this spec"
        end

        WebMock.allow_net_connect!
      end

      after(:all) do
        WebMock.disable_net_connect!
      end

      context 'Nexmo' do

        it "should successfuly send message" do
          message = \
            SmsBroker.service(:nexmo).message('test').to(ENV['REAL_PHONE_NUMBER'])

          response = message.deliver

          expect(response.success?).to eq true
        end

      end

      context 'Twillio' do

        it "should successfuly send message" do
          message = \
            SmsBroker.service(:twilio).message('test').to(ENV['REAL_PHONE_NUMBER'])

          response = message.deliver

          expect(response.success?).to eq true
        end

      end

    end

  end

end
