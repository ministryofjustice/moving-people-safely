require 'current_offence'

module Forms
  class Offences < Forms::Base
    prepopulated_collection :current_offences

    validate do
      validate_current_offences
    end

    def validate_current_offences
      errors.add(:base, :minimum_current_offence) unless current_offences.size >= 1
    end
  end
end
