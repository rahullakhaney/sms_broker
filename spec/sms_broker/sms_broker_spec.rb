describe SmsBroker do
  context 'SmsBroker' do
    let(:text_message) { 'Hello World' }
    let(:account_sid) { 'account_sid' }
    let(:auth_token) { 'auth_token' }

    context 'Invalid data when trying to deliver' do
      before(:each) do
        SmsBroker.clear_setup

        SmsBroker.setup do |config|
          config.services ['twilio']
          config.default_service 'twilio'
          config.twilio_setup \
            phone_number: '15005550001',
            account_sid: account_sid,
            auth_token: auth_token
        end
      end

      it 'should return error for missing number' do
        response = SmsBroker.service.message(text_message).to(nil).deliver

        expect(response.success?).to eq(false)
        expect(response.serialized[:errors][:to]).to include('is required')
      end

      it 'should return error for missing message' do
        response = SmsBroker.service.message(nil).to(nil).deliver

        expect(response.success?).to eq(false)
        expect(response.serialized[:errors][:message]).to include('is required')
      end

      it 'should return error for invalid message' do
        message_160 = 'Lorem Ipsum is simply dummy text of the printing and ' \
                      'typesetting industry. Lorem Ipsum has been the ' \
                      'industrys standard dummy text ever since the 1500s, ' \
                      'when an'

        response = \
          SmsBroker.service.message(message_160).to('44123457891').deliver

        expect(response.success?).to eq(false)
        expect(response.serialized[:errors][:message]).to \
          include('cannot have length greater than 140')
      end
    end

    context 'Invalid setup when trying to deliver' do
      before(:all) do
        SmsBroker.clear_setup

        SmsBroker.setup do |config|
          config.services ['nexmo']
          config.default_service 'nexmo'
          config.nexmo_setup \
            key: 'nexmo_api_key',
            secret: 'nexmo_api_secret',
            sender_id: 'nexmo_sender_id'
        end
      end

      it 'should return error for missing phone_number' do
        expect do
          SmsBroker.service.message(text_message).to('44123457891').deliver
        end.to raise_error SmsBroker::Exceptions::InvalidService
      end
    end
  end
end
