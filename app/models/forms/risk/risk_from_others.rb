module Forms
  module Risk
    class RiskFromOthers < Forms::Base
      optional_details_field :rule_45
      optional_details_field :verbal_abuse
      optional_details_field :physical_abuse

      concerning :CsraSection do
        included do
          CSRA_HIGH = 'high'.freeze
          CSRA_STANDARD = 'standard'.freeze
          CSRA_TOGGLE_CHOICES = [CSRA_HIGH, CSRA_STANDARD, DEFAULT_CHOICE].freeze

          _define_attribute_is_on(:csra, 'high')
          property(:csra, type: StrictString, default: DEFAULT_CHOICE)
          validates :csra,
            inclusion: { in: CSRA_TOGGLE_CHOICES },
            allow_blank: true

          property(:csra_details, type: StrictString)
          validates :csra_details,
            presence: true,
            if: -> { csra == CSRA_HIGH }

          reset attributes: %i[csra_details],
                if_falsey: :csra, enabled_value: CSRA_HIGH
        end

        def csra_toggle_choices
          CSRA_TOGGLE_CHOICES
        end

        def csra_toggle_field
          CSRA_HIGH
        end
      end
    end
  end
end
