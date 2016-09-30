module Considerations
  class OpenAcct < Consideration
    def prepopulate
      self.option ||= 'unknown'
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
      end
    end
  end
end
