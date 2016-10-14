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
          # binding.pry
        end
      end
    end
  end
end
