module Considerations
  class PastOffences < Consideration
    def reset
      self.offences = [] unless on?
      super
    end

    def prepopulate
      self.offences ||= []
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
        optional(:offences).each do
          schema do
            required(:offence).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
          end
        end

        rule(:"offences_presence" => [:option, :offences], &OPTIONAL_MULTIPLE_TEST)
      end
    end
  end
end
