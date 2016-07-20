module Forms
  module Risk
    class RiskFromOthers < Forms::Base
      CSRA_TOGGLE_CHOICES = %w[ high standard unknown ]

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
        if: -> { csra == 'high' || csra == 'standard' }

      def csra_toggle_choices
        CSRA_TOGGLE_CHOICES
      end
    end
  end
end
