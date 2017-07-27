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
        { name: name }
      end

      private

      attr_reader :seed_data, :code, :data

      def item
        @item ||= data['item'].first
      end

      def name
        item['name']
      end
    end
  end
end