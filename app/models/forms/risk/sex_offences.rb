module Forms
  module Risk
    class SexOffences < Forms::Base
      optional_field :sex_offence

      reset attributes: ::Risk.children_of(:sex_offence),
            if_falsey: :sex_offence

      property :sex_offence_victim, type: StrictString

      reset attributes: ::Risk.children_of(:sex_offence_victim),
            if_falsey: :sex_offence_victim, enabled_value: ::Risk.sex_offence_victim_on_values[0]

      property :sex_offence_details, type: StrictString

      validates :sex_offence_victim,
        inclusion: { in: ::Risk.sex_offence_victim_all_values },
        allow_blank: true

      validates :sex_offence_details,
        presence: true,
        if: -> { sex_offence == 'yes' && sex_offence_victim == ::Risk.sex_offence_victim_on_values[0] }

      def victim_values
        ::Risk.sex_offence_victim_all_values
      end
    end
  end
end
