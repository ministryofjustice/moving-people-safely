module Forms
  module Risk
    class SexOffences < Forms::Base
      UNDER_18 = 'under_18'.freeze
      VICTIM_VALUES = ['adult_male', 'adult_female', UNDER_18].freeze

      optional_field :sex_offence, default: 'unknown'

      validate :valid_sex_offence_options, if: proc { |f| f.sex_offence == 'yes' }

      def valid_sex_offence_options
        unless selected_sex_offence_options.any?
          errors.add(:base, :minimum_one_option, options: sex_offence_options.join(', '))
        end
      end

      optional_checkbox :sex_offence_adult_male_victim
      optional_checkbox :sex_offence_adult_female_victim
      optional_checkbox_with_details :sex_offence_under18_victim, :sex_offence

      reset attributes: %i[sex_offence_adult_male_victim sex_offence_adult_female_victim
                           sex_offence_under18_victim sex_offence_under18_victim_details],
            if_falsey: :sex_offence

      private

      def selected_sex_offence_options
        [sex_offence_adult_male_victim,
         sex_offence_adult_female_victim,
         sex_offence_under18_victim]
      end

      def sex_offence_options
        %i[sex_offence_adult_male_victim sex_offence_adult_female_victim
           sex_offence_under18_victim].map do |attr|
          I18n.t(attr, scope: [:helpers, :label, :sex_offences])
        end
      end
    end
  end
end
