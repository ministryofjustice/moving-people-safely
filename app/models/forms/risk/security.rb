module Forms
  module Risk
    class Security < Forms::Base
      E_RISK_VALUES = %w[e_list_standard e_list_escort e_list_heightened].freeze
      optional_field :current_e_risk, default: 'unknown'

      property :current_e_risk_details, type: StrictString
      reset attributes: %i[current_e_risk_details],
            if_falsey: :current_e_risk

      validates :current_e_risk_details,
        inclusion: { in: E_RISK_VALUES }, if: -> { current_e_risk == 'yes' }

      optional_field :previous_escape_attempts, default: 'unknown'

      validate :valid_previous_escape_attempts_options,
        if: -> { previous_escape_attempts == 'yes' }

      def valid_previous_escape_attempts_options
        if selected_previous_escape_attempts_options.none?
          errors.add(:base, :minimum_one_option, options: previous_escape_attempts_options.join(', '))
        end
      end

      optional_checkbox_with_details :prison_escape_attempt, :previous_escape_attempts
      optional_checkbox_with_details :court_escape_attempt, :previous_escape_attempts
      optional_checkbox_with_details :police_escape_attempt, :previous_escape_attempts
      optional_checkbox_with_details :other_type_escape_attempt, :previous_escape_attempts

      reset attributes: %i[
        prison_escape_attempt prison_escape_attempt_details
        court_escape_attempt court_escape_attempt_details
        police_escape_attempt police_escape_attempt_details
        other_type_escape_attempt other_type_escape_attempt_details
      ], if_falsey: :previous_escape_attempts

      optional_field :category_a, default: 'unknown'

      optional_field :escort_risk_assessment, default: 'unknown'
      property :escort_risk_assessment_completion_date, type: TextDate
      reset attributes: %i[escort_risk_assessment_completion_date],
            if_falsey: :escort_risk_assessment,
            enabled_value: 'yes'

      validates :escort_risk_assessment_completion_date,
        date: { not_in_the_future: true },
        if: -> { escort_risk_assessment == 'yes' }

      optional_field :escape_pack, default: 'unknown'
      property :escape_pack_completion_date, type: TextDate
      reset attributes: %i[escape_pack_completion_date],
            if_falsey: :escape_pack,
            enabled_value: 'yes'

      validates :escape_pack_completion_date,
        date: { not_in_the_future: true },
        if: -> { escape_pack == 'yes' }

      def e_risk_values
        E_RISK_VALUES
      end

      private

      def selected_previous_escape_attempts_options
        [prison_escape_attempt,
         court_escape_attempt,
         police_escape_attempt,
         other_type_escape_attempt]
      end

      def previous_escape_attempts_options
        translate_options(%i[prison_escape_attempt court_escape_attempt
                             police_escape_attempt other_type_escape_attempt], :security)
      end
    end
  end
end
