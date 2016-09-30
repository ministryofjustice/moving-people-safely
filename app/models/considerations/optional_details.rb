module Considerations
  class OptionalDetails < Consideration
    def reset
      self.details = '' unless on?
      super
    end

    def prepopulate
      self.option ||= 'unknown'
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
        optional(:details).maybe(:str?, max_size?: REASONABLE_STRING_LENGTH)
        rule(:details => [:option, :details], &OPTIONAL_DETAILS_TEST)
      end
    end
  end
end
