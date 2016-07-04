module Forms
  module Risks
    class SexOffences < Forms::Base
      VICTIM_VALUES = %w[ adult_male adult_female under_18 ]

      optional_field :sex_offence
      property :sex_offence_victim, type: StrictString
      property :sex_offence_details, type: StrictString

      validates :sex_offence_victim,
        inclusion: { in: VICTIM_VALUES },
        allow_blank: true

      validates :sex_offence_details,
        presence: true,
        if: -> { sex_offence == 'yes' }

      def victim_values
        VICTIM_VALUES
      end
    end
  end
end
