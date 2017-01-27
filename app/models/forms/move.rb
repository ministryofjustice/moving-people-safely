module Forms
  class Move < Forms::Base
    REASON_WITH_DETAILS = 'other'.freeze
    NOT_FOR_RELEASE_REASONS = %w[serving_sentence further_charges licence_revoke
                                 held_for_immigration other].freeze

    property :from, type: StrictString, default: 'HMP Bedford'
    property :to,   type: StrictString
    property :date, type: TextDate

    optional_field :not_for_release, default: 'unknown'
    reset attributes: %i[not_for_release_reason not_for_release_reason_details],
          if_falsey: :not_for_release

    optional_field :not_for_release_reason,
      type: StrictString,
      options: NOT_FOR_RELEASE_REASONS,
      option_with_details: REASON_WITH_DETAILS,
      default: 'unknown' do
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

    optional_field :has_destinations
    prepopulated_collection :destinations,
      collection_form_class: Forms::Moves::Destination

    delegate :persisted?, to: :model

    validate :validate_date

    def validate_date
      # TODO: extract a common date validator
      if date.is_a? Date
        errors[:date] << 'must not be in the past.' if date < Date.today
      else
        errors.add(:date)
      end
    end

    def save_copy
      sync
      model.save_copy
    end

    def not_for_release_reasons
      NOT_FOR_RELEASE_REASONS
    end

    def not_for_release_reason_with_details
      REASON_WITH_DETAILS
    end
  end
end
