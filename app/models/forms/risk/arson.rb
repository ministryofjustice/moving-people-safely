module Forms
  module Risk
    class Arson < Forms::Base
      ARSON_VALUES = %w[index_offence behavioural_issue small_risk].freeze

      optional_details_field :arson
      property :arson_value, type: StrictString
      optional_details_field :damage_to_property

      validates :arson_value,
        inclusion: { in: ARSON_VALUES },
        allow_blank: true

      def arson_values
        ARSON_VALUES
      end
    end
  end
end
