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

      optional_field :has_destinations
      prepopulated_collection :destinations

      delegate :persisted?, to: :model

      validates :reason,
        inclusion: { in: REASONS },
        allow_blank: true

      validates :reason_details,
        presence: true,
        if: -> { reason == 'other' }

      validate :validate_date

      def validate_date
        # TODO: extract a common date validator
        if date.is_a? Date
          errors[:date] << 'Date must not be in the past.' if date < Date.today
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
