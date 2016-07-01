describe SmsBroker do

  context 'Twilio' do

    context '#send_message' do

      let(:text_message) { 'Hello World' }
      let(:from_phone) { ENV['TWILIO_PHONE_NUMBER'] }
      let(:sender_id) { ENV['TWILIO_SENDER_ID'] }

      before(:each) do
        SmsBroker.clear_setup
      end

      def send_message(text, to)
        WebMock.allow_net_connect!

        response = SmsBroker.service.message(text).to(to).deliver

        WebMock.disable_net_connect!

        response
      end

      context 'valid' do

        it 'should send message with success' do
          SmsBroker.setup do |config|
            config.services ['twilio']

            config.default_service 'twilio'

            config.twilio_setup \
              phone_number: from_phone,
              account_sid: ENV['TWILIO_ACCOUNT_SID'],
              auth_token: ENV['TWILIO_AUTH_TOKEN']
          end

          response = send_message(text_message, '15005550006')

          expect(response.service).to eq(:twilio)
          expect(response.success?).to eq(true)
          expect(response.message_id).not_to eq(nil)
        end

        context 'with sender_id' do

          before(:each) do
            SmsBroker.setup do |config|
              config.services ['twilio']

              config.default_service 'twilio'

              config.twilio_setup \
                phone_number: ENV['TWILIO_PHONE_NUMBER'],
                account_sid: ENV['TWILIO_ACCOUNT_SID'],
                auth_token: ENV['TWILIO_AUTH_TOKEN'],
                sender_id: 'NotAValidSenderId'
            end
          end

          it 'should return error for invalid sender_id' do
            response = send_message(text_message, '15005550002')

            expect(response.service).to eq(:twilio)

            expect(response.success?).to eq(false)

            expect(response.serialized.keys).to include('21612')

            # if the code is 21612 and message includes the phone_number,
            # it means that it tried with sender_id and failed
            expect(response.serialized['21612'][0]).to \
              include("From' phone number: #{ENV['TWILIO_PHONE_NUMBER']}")
          end

        end

      end

      context 'invalid' do

        it 'should return error for missing required data' do
          SmsBroker.setup do |config|
            config.services ['twilio']

            config.default_service 'twilio'

            config.twilio_setup \
              phone_number: '15005550001',
              account_sid: ENV['TWILIO_ACCOUNT_SID'],
              auth_token: ENV['TWILIO_AUTH_TOKEN']
          end

          response = SmsBroker.message(text_message).deliver

          expect(response.serialized[:to]).to include('is required')
        end

        it 'should return error for invalid from phone' do
          SmsBroker.setup do |config|
            config.services ['twilio']

            config.default_service 'twilio'

            config.twilio_setup \
              phone_number: '15005550001',
              account_sid: ENV['TWILIO_ACCOUNT_SID'],
              auth_token: ENV['TWILIO_AUTH_TOKEN']
          end

          response = send_message(text_message, '15005550006')

          expect(response.success?).to eq(false)
          expect(response.serialized.length).to be > 0
        end

      end

    end

  end

end
