module Considerations
  class EscapeRisk < OptionalDetails
    DETAILS_VALUES = %w[ e_list_standard e_list_escort e_list_heightened ]

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
        optional(:details).maybe(included_in?: DETAILS_VALUES)
        rule(:details_presence => [:option, :details], &OPTIONAL_DETAILS_TEST)
      end
    end

    def values
      DETAILS_VALUES
    end
  end
end
