describe SmsBroker do
  context 'Twilio' do
    context '#send_message' do
      let(:text_message) { 'Hello World' }
      let(:from_phone) { '15005550006' }
      let(:account_sid) { 'account_sid' }
      let(:auth_token) { 'auth_token' }

      before(:each) do
        SmsBroker.clear_setup
      end

      def send_message(text_message, to)
        SmsBroker.service.message(text_message).to(to).deliver
      end

      context 'valid' do
        it 'should send message with success' do
          SmsBroker.setup do |config|
            config.services ['twilio']
            config.default_service 'twilio'
            config.twilio_setup \
              phone_number: from_phone,
              account_sid: account_sid,
              auth_token: auth_token
          end

          VCR.use_cassette('twilio/create_success') do
            response = send_message(text_message, '15005550006')

            expect(response.service).to eq(:twilio)
            expect(response.success?).to eq(true)
            expect(response.message_id).not_to eq(nil)
          end
        end

        context 'with sender_id' do
          before(:each) do
            SmsBroker.setup do |config|
              config.services ['twilio']
              config.default_service 'twilio'
              config.twilio_setup \
                phone_number: '15005550001',
                account_sid: account_sid,
                auth_token: auth_token
            end
          end

          it 'should return 21212 error for invalid sender_id' do
            VCR.use_cassette('twilio/create_invalid_phone_error') do
              response = send_message(text_message, '15005550006')

              expect(response.service).to eq(:twilio)
              expect(response.success?).to eq(false)
              expect(response.serialized[:errors].keys).to include('21212')
              # if the code is 21212 and message includes the phone_number,
              # it means that it tried with sender_id and failed
              expect(response.serialized[:errors]['21212'][0]).to \
                include("The 'From' number +15005550001 is not a valid")
            end
          end

          it 'should return 21612 error for invalid sender_id' do
            VCR.use_cassette('twilio/create_invalid_phone_error_21612') do
              response = send_message(text_message, '15005550006')

              expect(response.service).to eq(:twilio)
              expect(response.success?).to eq(false)
              expect(response.serialized[:errors].keys).to include('21612')
              # if the code is 21212 and message includes the phone_number,
              # it means that it tried with sender_id and failed
              expect(response.serialized[:errors]['21612'][0]).to \
                include("The 'From' number +15005550001 is not a valid")
            end
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
              account_sid: account_sid,
              auth_token: auth_token
          end

          response = SmsBroker.message(text_message).deliver

          expect(response.serialized[:errors][:to]).to include('is required')
        end

        it 'should return error for invalid from phone' do
          SmsBroker.setup do |config|
            config.services ['twilio']
            config.default_service 'twilio'
            config.twilio_setup \
              phone_number: '15005550001',
              account_sid: account_sid,
              auth_token: auth_token
          end

          VCR.use_cassette('twilio/create_invalid_phone_error') do
            response = send_message(text_message, '15005550006')

            expect(response.success?).to eq(false)
            expect(response.serialized.length).to be > 0
          end
        end
      end
    end
  end
end
