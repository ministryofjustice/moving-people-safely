module Considerations
  class Clinician < Consideration
    def prepopulate
      self.healthcare_professional ||= ''
      self.contact_number ||= ''
    end

    def schema
      Dry::Validation.Form do
        required(:healthcare_professional).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
        required(:contact_number).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
      end
    end
  end
end


