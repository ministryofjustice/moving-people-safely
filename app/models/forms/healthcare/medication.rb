module Forms
  module Healthcare
    class Medication < Forms::Base
      CARRIER_VALUES = %w[escort detainee].freeze

      property :description,    type: StrictString
      property :administration, type: StrictString
      property :carrier,        type: StrictString
      property :_delete,
        type: Axiom::Types::Boolean,
        default: false,
        virtual: true

      validates :carrier,
        inclusion: { in: CARRIER_VALUES },
        allow_blank: true

      validates :description, presence: true

      def carrier_values
        CARRIER_VALUES
      end
    end
  end
end
