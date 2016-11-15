require 'current_offence'

module Forms
  class Offences < Forms::Base
    property :release_date, type: TextDate, validates: { presence: true, allow_nil: true }

    optional_checkbox :not_for_release

    prepopulated_collection :current_offences

    optional_field :has_past_offences
    prepopulated_collection :past_offences

    validate :validate_release_date

    def validate_release_date
      return if release_date.nil?
      errors.add(:release_date) unless release_date.is_a?(Date)
    end
  end
end
