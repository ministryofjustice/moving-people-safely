module Considerations
  class SexOffence < OptionalDetails
    VICTIM_VALUES = %w[ adult_male adult_female under_18 ]
    VICTIM_ON_VALUE = 'under_18'

    def reset
      victim = '' unless option == TERNARY_ON_VALUE
      details = '' unless victim == VICTIM_ON_VALUE
      super
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
        optional(:victim).maybe(included_in?: VICTIM_VALUES)
        optional(:details).maybe(:str?, max_size?: REASONABLE_STRING_LENGTH)
        rule(:details_presence => [:victim, :details]) do |_victim, _details|
          _victim.eql?(VICTIM_ON_VALUE) > _details.filled?
        end
      end
    end
  end
end
