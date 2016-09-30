module Considerations
  class InterpreterRequired < Consideration
    def reset
      language = '' unless on?
      super
    end

    def prepopulate
      self.option ||= 'unknown'
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
        optional(:language).maybe(:str?, max_size?: REASONABLE_STRING_LENGTH)
        rule(:language => [:option, :language], &OPTIONAL_DETAILS_TEST)
      end
    end
  end
end


