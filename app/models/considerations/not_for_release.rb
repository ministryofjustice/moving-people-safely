module Considerations
  class NotForRelease < Consideration
    def reset
      details = '' unless option
      super
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(:bool?)
        optional(:details).maybe(:str?, max_size?: REASONABLE_STRING_LENGTH)

        rule(optional_details: [:option, :details], &BOOLEAN_OPTIONAL_DETAILS_TEST)
      end
    end
  end
end
