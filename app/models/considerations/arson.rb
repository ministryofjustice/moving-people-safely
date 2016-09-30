module Considerations
  class Arson < OptionalDetails
    MORE_INFO_VALUES = %w[ index_offence behavioural_issue small_risk ]

    def reset
      unless on?
        more_info = ''
        details = ''
      end
      super
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
        optional(:more_info).maybe(included_in?: MORE_INFO_VALUES)
        optional(:details).maybe(:str?, max_size?: REASONABLE_STRING_LENGTH)
        rule(:details_presence => [:option, :details], &OPTIONAL_DETAILS_TEST)
        rule(:more_info_presence => [:option, :more_info], &OPTIONAL_DETAILS_TEST)
      end
    end

    def arson_values
      MORE_INFO_VALUES
    end
  end
end
