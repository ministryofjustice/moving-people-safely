# frozen_string_literal: true

module Forms
  module Healthcare
    class Medication < Forms::Base
      CARRIER_VALUES = %w[escort prisoner].freeze

      property :description,    type: StrictString
      property :administration, type: StrictString
      property :dosage,         type: StrictString
      property :when_given,     type: StrictString
      property :carrier,        type: StrictString
      property :_delete,
        type: Axiom::Types::Boolean,
        default: false,
        virtual: true

      validates :description,    presence: true
      validates :administration, presence: true
      validates :dosage,         presence: true
      validates :when_given,     presence: true
      validates :carrier,
        inclusion: { in: CARRIER_VALUES },
        allow_blank: true

      def carrier_values
        CARRIER_VALUES
      end
    end
  end
end
