module Forms
  module Police
    class Move < Forms::Move
      NOT_FOR_RELEASE_REASONS = %w[prison_production recall_to_prison] +
                                COMMON_NOT_FOR_RELEASE_REASONS

      optional_field :not_for_release_reason,
        type: StrictString,
        options: NOT_FOR_RELEASE_REASONS,
        option_with_details: REASON_WITH_DETAILS do
          validates :not_for_release_reason,
            inclusion: { in: NOT_FOR_RELEASE_REASONS },
            if: -> { not_for_release == 'yes' }
        end

      reset attributes: %i[not_for_release_reason not_for_release_reason_details],
            if_falsey: :not_for_release

      reset attributes: [:not_for_release_reason_details],
            if_falsey: :not_for_release_reason,
            enabled_value: REASON_WITH_DETAILS

      def not_for_release_reasons
        NOT_FOR_RELEASE_REASONS
      end
    end
  end
end
