module Forms
  module Risk
    class Harassments < Forms::Base
      optional_details_field :harassment, default: 'unknown'

      optional_field :intimidation, default: 'unknown'
      optional_checkbox_with_details :intimidation_to_staff, :intimidation
      optional_checkbox_with_details :intimidation_to_public, :intimidation
      optional_checkbox_with_details :intimidation_to_other_detainees, :intimidation
      optional_checkbox_with_details :intimidation_to_witnesses, :intimidation

      reset attributes: %i[
        intimidation_to_staff intimidation_to_staff_details
        intimidation_to_public intimidation_to_public_details
        intimidation_to_other_detainees intimidation_to_other_detainees_details
        intimidation_to_witnesses intimidation_to_witnesses_details
      ], if_falsey: :intimidation
    end
  end
end
