module Forms
  module Risk
    class RiskFromOthers < Forms::Base
      optional_details_field :rule_45
      optional_details_field :verbal_abuse
      optional_details_field :physical_abuse

      concerning :CsraSection do
        included do
          _define_attribute_is_on(:csra, 'high')
          property(:csra, type: StrictString, default: DEFAULT_CHOICE)
          validates :csra,
            inclusion: { in: ::Risk.csra_all_values },
            allow_blank: true

          property(:csra_details, type: StrictString)
          validates :csra_details,
            presence: true,
            if: -> { csra == ::Risk.csra_on_values[0] }

          reset attributes: ::Risk.children_of(:csra),
                if_falsey: :csra, enabled_value: ::Risk.csra_on_values[0]
        end

        def csra_toggle_choices
          ::Risk.csra_all_values
        end
      end
    end
  end
end
