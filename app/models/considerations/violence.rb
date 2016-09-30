module Considerations
  class Violence < Consideration
    FIELDS = %i[ prison_staff risk_to_females escort_or_court_staff healthcare_staff other_detainees homophobic racist public_offence_related police ]

    def reset
      fields.each do |field|
        if option != TERNARY_ON_VALUE
          public_send("#{field}=", false)
          public_send("#{field}_details=", '')
        elsif !public_send("#{field}")
          public_send("#{field}_details=", '')
        end
      end
      super
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)

        FIELDS.each do |checkbox|
          details = :"#{checkbox}_details"
          optional(checkbox).filled(:bool?)
          optional(details).maybe(:str?, max_size?: REASONABLE_STRING_LENGTH)
          rule(:"#{checkbox}_presence" => [:option, checkbox, details], &TERNARY_TEST)
        end
      end
    end

    def fields
      FIELDS
    end
  end
end
