require 'pry'

describe SmsBroker do
  context 'Nexmo', :focus do
    context '#send_message' do
      let(:voice_message) { 'Hello World' }
      let(:from_phone) { '+447476543210' }
      let(:sender_id) { 'SenderID' }
      let(:lang) { 'en-GB' }
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

          stub_nexmo_create_voice_message_success(sender_id, to_phone, voice_message, lang)

          response = SmsBroker
            .voice_message(voice_message)
            .to(to_phone)
            .with(lang: lang)
            .deliver

          expect(response.service).to eq(:nexmo)
          expect(response.success?).to eq(true)
          expect(response.call_id).not_to eq(nil)
        end
      end

      context 'with rate and repeate set', :focus do
        it 'should send voice message with success' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              sender_id: sender_id,
              secret: api_secret,
              key: api_key
          end

          #stub_nexmo_create_voice_message_success(sender_id, to_phone, voice_message, lang)

          sms_broker = SmsBroker
            .voice_message(voice_message)
            .to(to_phone)
            .with(lang: lang, rate: 20, repeate: 3)
          sms_broker.build_message
          messages = \
            sms_broker.voice_message_text.split("<break time='1s'/>")

          expect(messages.count).to eq(3)
          messages.each do |message|
            expect(message).to eq("<prosody rate='20%'>Hello World</prosody>")
          end
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

        it 'should return error an unknown error' do
          SmsBroker.setup do |config|
            config.nexmo_setup \
              phone_number: from_phone,
              secret: api_secret,
              key: api_key
          end

          stub_nexmo_create_voice_message_unknown_error \
            from_phone, to_phone, voice_message

          response = SmsBroker.voice_message(voice_message).to(to_phone).deliver

          expect(response.success?).to eq(false)
          expect(response.serialized.length).to be > 0
        end
      end
    end
  end
end
