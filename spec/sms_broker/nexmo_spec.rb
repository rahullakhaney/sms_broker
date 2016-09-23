describe SmsBroker do
  context 'Nexmo' do
    context '#send_message' do
      let(:text_message) { 'Hello World' }
      let(:from_phone) { '+447476543210' }
      let(:sender_id) { 'SenderID' }
      let(:to_phone) { '+447491234567' }
      let(:api_secret) { 'api_secret' }
      let(:api_key) { 'api_key' }

      before(:each) do
        SmsBroker.clear_setup
      end

      context 'valid' do
        it 'should send message with success' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              sender_id: sender_id,
              secret: api_secret,
              key: api_key
          end

          stub_nexmo_create_message_success(sender_id, to_phone, text_message)

          response = SmsBroker.message(text_message).to(to_phone).deliver

          expect(response.service).to eq(:nexmo)
          expect(response.success?).to eq(true)
          expect(response.message_id).not_to eq(nil)
        end

        it 'should return error for invalid sender_id and fallback to ' \
           'phone_number' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              sender_id: sender_id,
              secret: api_secret,
              key: api_key
          end

          stub_nexmo_create_message_invalid_sender_id_request \
            sender_id, to_phone, text_message

          stub_nexmo_create_message_success \
            from_phone, to_phone, text_message

          response = SmsBroker.message(text_message).to(to_phone).deliver

          expect(response.success?).to eq(true)
          # this means that it tried to send with sender_id and failed
          # and then sent with from_phone
          expect(response.from).to eq(from_phone)
        end
      end

      context 'invalid' do
        it 'should return error for invalid credentials' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              secret: 'invalid',
              key: 'invalid'
          end

          stub_nexmo_create_message_invalid_credentials \
            from_phone, to_phone, text_message

          response = SmsBroker.message(text_message).to(to_phone).deliver

          expect(response.success?).to eq(false)
          expect(response.serialized.length).to be > 0
        end

        it 'should return error an unknown error' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              secret: api_secret,
              key: api_key
          end

          stub_nexmo_create_message_unknown_error \
            from_phone, to_phone, text_message

          response = SmsBroker.message(text_message).to(to_phone).deliver

          expect(response.success?).to eq(false)
          expect(response.serialized.length).to be > 0
        end
      end
    end
  end
end
