module Forms
  module Risk
    class SubstanceMisuse < Forms::Base
      SUBSTANCE_SUPPLY_VALUES = %w[drugs alcohol both].freeze

      optional_field :substance_supply, default: 'unknown'
      property :substance_supply_details, type: StrictString

      reset attributes: %i[substance_supply_details], if_falsey: :substance_supply

      validates :substance_supply_details,
        inclusion: { in: SUBSTANCE_SUPPLY_VALUES },
        if: -> { substance_supply == 'yes' }

      def substance_supply_values
        SUBSTANCE_SUPPLY_VALUES
      end
    end
  end
end
