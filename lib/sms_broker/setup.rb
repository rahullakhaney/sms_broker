module SmsBroker
  class Setup
    attr_reader :options,
                :errors

    def self.service_validation_schemas
      {
        nexmo: Compel.hash.keys({
          key: Compel.string.required,
          secret: Compel.string.required,
          sender_id: Compel.string,
          phone_number: Compel.string.required
        }),
        twilio: Compel.hash.keys({
          sender_id: Compel.string,
          auth_token: Compel.string.required,
          account_sid: Compel.string.required,
          phone_number: Compel.string.required
        })
      }
    end

    def initialize
      @errors = {}
      @options = {
        services: ['nexmo'],
        default_service: 'nexmo',
        services_setups: {}
      }
    end

    def services(services)
      @options[:services] = services
    end

    def default_service(service)
      @options[:default_service] = service
    end

    def valid?
      result = compel_validation_schema(@options[:services]).validate(@options)

      @errors = result.errors

      result.valid?
    end

    def compel_validation_schema(services_list = [])
      not_all_services_setup = Proc.new do |services_setups|
        services_list.all?{ |service|
          services_setups.keys.include?(service.to_sym)
        }
      end

      services_setups_schema = \
        Compel.hash.required
          .keys(Setup.service_validation_schemas)
          .if(not_all_services_setup, message: 'all services must be setup')

      Compel.hash.keys \
        services: Compel.array.required.min_length(1),
        default_service: Compel.string.required.in(services_list),
        services_setups: services_setups_schema
    end

    def method_missing(method, args, &block)
      service = "#{method}".split('_setup')[0].dup

      if @options[:services].include?(service)
        @options[:services_setups][service.to_sym] = args
        @options[:services_setups]
      else

        super
      end
    end
  end
end
