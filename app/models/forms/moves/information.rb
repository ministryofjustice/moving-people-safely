module Forms
  module Moves
    class Information < Forms::Base
      REASON_WITH_DETAILS = 'other'.freeze
      REASONS = (%w[
        discharge_to_court
        production_to_court
        police_production
      ] + [REASON_WITH_DETAILS]).freeze

      property :from,             type: StrictString, default: 'HMP Bedford'
      property :to,               type: StrictString
      property :date,             type: TextDate

      property_with_details :reason,
        type: StrictString,
        options: REASONS,
        option_with_details: REASON_WITH_DETAILS

      optional_field :has_destinations
      prepopulated_collection :destinations

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

      def reasons
        REASONS
      end

      def save_copy
        sync
        model.save_copy
      end
    end
  end
end
