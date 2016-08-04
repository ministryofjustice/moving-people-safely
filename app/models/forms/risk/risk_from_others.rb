module Forms
  module Risk
    class RiskFromOthers < Forms::Base
      CSRA_HIGH = 'high'
      CSRA_STANDARD = 'standard'
      CSRA_TOGGLE_CHOICES = [CSRA_HIGH, CSRA_STANDARD, DEFAULT_CHOICE]

      optional_details_field :rule_45
      optional_details_field :verbal_abuse
      optional_details_field :physical_abuse

      property(:csra, type: StrictString, default: DEFAULT_CHOICE)
      validates :csra,
        inclusion: { in: CSRA_TOGGLE_CHOICES },
        allow_blank: true

      property(:csra_details, type: StrictString)
      validates :csra_details,
        presence: true,
        if: -> { csra == CSRA_HIGH || csra == CSRA_STANDARD }

      def csra_toggle_choices
        CSRA_TOGGLE_CHOICES
      end
    end
  end
end
