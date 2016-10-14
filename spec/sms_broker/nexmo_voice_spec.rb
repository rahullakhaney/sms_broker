require 'pry'

describe SmsBroker do
  context 'Nexmo', :focus do
    context '#send_message' do
      let(:voice_message) { 'Hello World' }
      let(:from_phone) { '+447476543210' }
      let(:sender_id) { 'SenderID' }
      let(:to_phone) { '+447491234567' }
      let(:api_secret) { 'api_secret' }
      let(:api_key) { 'api_key' }

      before(:each) do
        SmsBroker.clear_setup
      end

      context 'valid', :focus do
        it 'should send voice message with success' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              sender_id: sender_id,
              secret: api_secret,
              key: api_key
          end

          stub_nexmo_create_voice_message_success(sender_id, to_phone, voice_message)

          response = SmsBroker.voice_message(voice_message).to(to_phone).deliver

          expect(response.service).to eq(:nexmo)
          expect(response.success?).to eq(true)
          expect(response.call_id).not_to eq(nil)
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

          stub_nexmo_create_voice_message_invalid_credentials \
            from_phone, to_phone, voice_message

          response = SmsBroker.voice_message(voice_message).to(to_phone).deliver

          expect(response.success?).to eq(false)
          expect(response.serialized.length).to be > 0
        end

        xit 'should return error an unknown error' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              secret: api_secret,
              key: api_key
          end

          stub_nexmo_create_message_unknown_error \
            from_phone, to_phone, voice_message

          response = SmsBroker.voice_message(voice_message).to(to_phone).deliver

          expect(response.success?).to eq(false)
          expect(response.serialized.length).to be > 0
        end
      end
    end
  end
end
