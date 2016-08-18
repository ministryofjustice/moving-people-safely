module Forms
  module Risk
    class SexOffences < Forms::Base
      UNDER_18 = 'under_18'
      VICTIM_VALUES = ['adult_male', 'adult_female', UNDER_18]

      optional_field :sex_offence

      reset attributes: %i[sex_offence_victim sex_offence_details],
            if_falsey: :sex_offence

      property :sex_offence_victim, type: StrictString
      property :sex_offence_details, type: StrictString

      validates :sex_offence_victim,
        inclusion: { in: VICTIM_VALUES },
        allow_blank: true

      validates :sex_offence_details,
        presence: true,
        if: -> { sex_offence == 'yes' && sex_offence_victim == UNDER_18 }

      def victim_values
        VICTIM_VALUES
      end
    end
  end
end
