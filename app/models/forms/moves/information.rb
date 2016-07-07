module Forms
  module Moves
    class Information < Forms::Base
      REASONS = %w[
        discharge_to_court
        production_to_court
        police_production
        other
      ]

      property :from,             type: StrictString, default: 'HMP Bedford'
      property :to,               type: StrictString
      property :date,             type: TextDate
      property :reason,           type: StrictString
      property :reason_details,   type: StrictString

      optional_field :destination
      prepopulated_collection :destinations

      validates :reason,
        inclusion: { in: REASONS },
        allow_blank: true

      validates :reason_details,
        presence: true,
        if: -> { reason == 'other' }

      validate :validate_date

      def validate_date
        # TODO: extract a common date validator
        errors.add(:date) unless date.is_a? Date
      end

      def reasons
        REASONS
      end
    end
  end
end
