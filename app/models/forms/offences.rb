module Forms
  class Offences < Forms::Base
    prepopulated_collection :offences

    validate do
      validate_offences
    end

    def validate_offences
      errors.add(:base, :minimum_current_offence) unless offences.size >= 1
    end
  end
end
