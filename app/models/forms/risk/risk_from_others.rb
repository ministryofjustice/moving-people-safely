module Forms
  module Risk
    class RiskFromOthers < Forms::Base
      optional_field :rule_45
      optional_field :victim_of_abuse, default: 'unknown'
      property :victim_of_abuse_details, type: StrictString
      reset attributes: [:victim_of_abuse_details], if_falsey: :victim_of_abuse
      optional_field :high_profile, default: 'unknown'
      property :high_profile_details, type: StrictString
      reset attributes: [:high_profile_details], if_falsey: :high_profile

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
        end

        def csra_toggle_choices
          CSRA_TOGGLE_CHOICES
        end
      end
    end
  end
end
