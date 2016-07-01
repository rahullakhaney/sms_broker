module SmsBroker
  module Client

    class Base

      attr_reader :name,
                  :client,
                  :options,
                  :sender_id,
                  :phone_number

      def initialize(name, client)
        @name = name
        @client = client
      end

      def serialize_number(number)
        "#{number}".dup.gsub(/\+/, '')
      end

    end

  end
end
