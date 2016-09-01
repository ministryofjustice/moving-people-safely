module Considerations
  class Harassment < Consideration
    FIELDS = %i[ hostage_taker stalker harasser intimidator bully ]

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



