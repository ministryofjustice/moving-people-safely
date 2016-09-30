module Considerations
  class MoveDestinations < Consideration
    MUST_RETURN_VALUES = %w[ must_return must_not_return unknown ]

    def must_return_values
      MUST_RETURN_VALUES
    end

    def reset
      destinations = [] if has_destinations != TERNARY_ON_VALUE
      super
    end

    def schema
      Dry::Validation.Form do
        required(:has_destinations).filled(included_in?: TERNARY_OPTIONS)
        required(:destinations).each do
          schema do
            required(:establishment).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
            required(:must_return).filled(included_in?: MUST_RETURN_VALUES)
            required(:reasons).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
          end
        end

        rule(destinations_presence: [:has_destinations, :destinations], &OPTIONAL_MULTIPLE_TEST)
      end
    end
  end
end
