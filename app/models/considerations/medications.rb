module Considerations
  class Medications < Consideration
    CARRIER_VALUES = %w[ escort detainee ]

    def carrier_values
      CARRIER_VALUES
    end

    def prepopulate
      self.option ||= 'unknown'
      self.collection ||= []
    end

    def add
      self.collection ||= []
      self.collection += [{
        description: '',
        administration: '',
        carrier: ''
      }]
    end

    def reset
      self.collection = [] unless on?
      super
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: TERNARY_OPTIONS)
        required(:collection).each do
          schema do
            required(:description).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
            required(:administration).filled(:str?, max_size?: REASONABLE_STRING_LENGTH)
            required(:carrier).filled(included_in?: CARRIER_VALUES)
          end
        end

        rule(:"#medications_presence" => [:option, :collection], &OPTIONAL_MULTIPLE_TEST)
      end
    end
  end
end
