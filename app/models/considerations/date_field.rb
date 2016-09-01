module Considerations
  class DateField < Consideration
    DATE_REGEX = /\d\d?\/\d\d?\/\d\d\d\d/

    def schema
      Dry::Validation.Form do
        required(:date).maybe(:str?, format?: DATE_REGEX)
      end
    end
  end
end
