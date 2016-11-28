require 'current_offence'

module Forms
  class Offences < Forms::Base
    property :release_date, type: TextDate, validates: { presence: true, allow_nil: true }

    optional_checkbox :not_for_release

    prepopulated_collection :current_offences

    optional_field :has_past_offences, options: %w[yes no]
    prepopulated_collection :past_offences

    validate do
      validate_release_date
      validate_current_offences
    end

    def validate_release_date
      return if release_date.nil?
      errors.add(:release_date) unless release_date.is_a?(Date)
    end

    def validate_current_offences
      errors.add(:base, :minimum_current_offence) unless current_offences.size >= 1
    end
  end
end
