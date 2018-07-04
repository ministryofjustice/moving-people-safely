module Seeds
  module Entries
    class Prison
      def initialize(seed_data)
        @seed_data = seed_data
        @data = seed_data[1]
        @code = @data['key']
      end

      def nomis_id
        "#{code}I"
      end

      def to_h
        { name: name, end_date: end_date, nomis_id: nomis_id,
          healthcare_contact_number: healthcare_contact_number }
      end

      private

      attr_reader :seed_data, :code, :data

      def item
        @item ||= data['item'].first
      end

      def name
        item['name']
      end

      def end_date
        item['end-date']
      end

      def healthcare_contact_number
        item['healthcare_contact_number']
      end
    end
  end
end
