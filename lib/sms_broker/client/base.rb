module SmsBroker
  module Client

    class Base

      attr_reader :name,
                  :client,
                  :sender_id,
                  :phone_number

      def initialize(name, client, options = {})
        @name = name
        @client = client
        @sender_id = options[:sender_id]
        @phone_number = options[:phone_number]
      end

      def serialize_number(number)
        "#{number}".delete("+")
      end

    end

  end
end
