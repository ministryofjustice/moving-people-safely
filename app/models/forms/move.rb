module Forms
  class Move < Forms::Base
    REASON_WITH_DETAILS = 'other'.freeze
    NOT_FOR_RELEASE_REASONS = %w[serving_sentence further_charges licence_revoke
                                 held_for_immigration other].freeze

    property :from, type: StrictString, default: 'HMP Bedford', validates: { presence: true }
    property :to,   type: StrictString, validates: { presence: true }
    property :date, type: TextDate

    optional_field :not_for_release,
      options: TOGGLE_CHOICES,
      allow_blank: false
    reset attributes: %i[not_for_release_reason not_for_release_reason_details],
          if_falsey: :not_for_release

    optional_field :not_for_release_reason,
      type: StrictString,
      options: NOT_FOR_RELEASE_REASONS,
      option_with_details: REASON_WITH_DETAILS do
      validates :not_for_release_reason,
        inclusion: { in: NOT_FOR_RELEASE_REASONS },
        if: -> { not_for_release == 'yes' }
    end

    property :not_for_release_reason_details, type: StrictString
    validates :not_for_release_reason_details,
      presence: true,
      if: -> { not_for_release == 'yes' && not_for_release_reason == REASON_WITH_DETAILS }
    reset attributes: [:not_for_release_reason_details],
          if_falsey: :not_for_release_reason,
          enabled_value: REASON_WITH_DETAILS

    delegate :persisted?, to: :model

    validates :date, date: { not_in_the_past: true }

    def not_for_release_reasons
      NOT_FOR_RELEASE_REASONS
    end

    def not_for_release_reason_with_details
      REASON_WITH_DETAILS
    end
  end
end
