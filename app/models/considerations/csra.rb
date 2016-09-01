module Considerations
  class Csra < Consideration
    CSRA_OPTIONS = %w[ high standard unknown ]
    CSRA_HIGH = 'high'

    def on?
      option == CSRA_HIGH
    end

    def toggle_choices
      CSRA_OPTIONS
    end

    def reset
      details = '' unless on?
      super
    end

    def prepopulate
      self.option = 'unknown'
    end

    def schema
      Dry::Validation.Form do
        required(:option).filled(included_in?: CSRA_OPTIONS)
        optional(:details).maybe(:str?, max_size?: REASONABLE_STRING_LENGTH)
        rule(:details_presence => [:option, :details]) do |_option, _details|
          _option.eql?(CSRA_HIGH) > _details.filled?
        end
      end
    end
  end
end
