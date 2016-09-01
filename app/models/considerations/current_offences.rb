module Considerations
  class CurrentOffences < Consideration
    def prepopulate
      self.offences ||= [{offence: '', case_reference: ''}]
    end

    def schema
      Dry::Validation.Form do
        required(:offences).each do
          schema do
            required(:offence).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
            required(:case_reference).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
          end
        end
      end
    end
  end
end
