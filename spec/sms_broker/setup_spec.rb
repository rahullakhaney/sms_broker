describe SmsBroker do

  context 'Setup' do

    before(:each) do
      SmsBroker.clear_setup
    end

    it 'should set configs' do
      setup = \
        SmsBroker.setup do |config|
          config.services ['nexmo', 'twilio']

          config.default_service 'nexmo'

          config.nexmo_setup \
            key: 'NEXMO_API_KEY',
            phone_number: 'phone',
            secret: 'NEXMO_API_KEY'

          config.twilio_setup \
            phone_number: 'phone',
            account_sid: 'TWILIO_ACCOUNT_SID',
            auth_token: 'TWILIO_AUTH_TOKEN'
        end

      expect(setup.valid?).to eq(true)

      expect(setup.options[:services]).to \
        eq(['nexmo', 'twilio'])

      expect(setup.options[:default_service]).to \
        eq('nexmo')

      expect(setup.options[:services_setups][:nexmo]).to \
        eq \
          key: 'NEXMO_API_KEY',
          secret: 'NEXMO_API_KEY',
          phone_number: 'phone'

      expect(setup.options[:services_setups][:twilio]).to \
        eq \
          phone_number: 'phone',
          account_sid: 'TWILIO_ACCOUNT_SID',
          auth_token: 'TWILIO_AUTH_TOKEN'
    end

    context 'valid configs' do

      before(:each) do
        SmsBroker.setup do |config|
          config.services ['nexmo', 'twilio']

          config.default_service 'nexmo'

          config.nexmo_setup \
            key: 'NEXMO_API_KEY',
            phone_number: 'phone',
            secret: 'NEXMO_API_KEY'

          config.twilio_setup \
            phone_number: 'phone',
            account_sid: 'TWILIO_ACCOUNT_SID',
            auth_token: 'TWILIO_AUTH_TOKEN'
        end
      end

      it 'should get default Service' do
        service = SmsBroker.service

        expect(service.client).to be_a SmsBroker::Client::Nexmo
      end

      it 'should get custom Service' do
        service = SmsBroker.service(:twilio)

        expect(service.client).to be_a SmsBroker::Client::Twilio
      end

    end

    context 'invalid configs' do

      it 'should return error about available services' do
        setup = SmsBroker.setup do |config|
          config.services ['nexmo', 'twilio']

          config.default_service 'nexmo'
        end

        expect(setup.valid?).to eq(false)
        expect(setup.errors).to eq \
          services_setups: [
            'all services must be setup'
          ]
      end

      it 'should return error for not having services' do
        setup = SmsBroker.setup do |config|
          config.services []
        end

        expect(setup.valid?).to eq(false)

        expect(setup.errors[:services]).to \
          include('cannot have length less than 1')
      end

      it 'should return error default_service' do
        setup = SmsBroker.setup do |config|
          config.services ['nexmo', 'twilio']

          config.default_service 'nope'
        end

        expect(setup.valid?).to eq(false)

        expect(setup.errors[:default_service]).to \
          include("must be within [\"nexmo\", \"twilio\"]")
      end

      context 'setup!' do

        it 'should raise exception for invalid setup' do
          expect {
            SmsBroker.setup! do |config|
              config.services ['nexmo', 'twilio']
              config.default_service 'nope'
            end
          }.to raise_error(SmsBroker::Exceptions::InvalidSetup)
        end

        it 'should return error for missing required service setup' do
          expect {
            SmsBroker.setup! do |config|
              config.default_service 'nexmo'

              config.nexmo_setup \
                not_exists: 'key'
            end
          }.to raise_error(SmsBroker::Exceptions::InvalidSetup)
        end

      end

    end

  end

  it 'should respond_to :message' do
    expect(SmsBroker.respond_to?(:message)).to eq(true)
  end

  it 'should raise InvalidSetup for service not being setup' do
    SmsBroker.clear_setup

    expect{ SmsBroker::Service.get(:twilio) }.to \
      raise_error SmsBroker::Exceptions::InvalidSetup
  end

end
