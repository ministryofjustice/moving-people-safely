module Forms
  module Risk
    class ConcealedWeapons < Forms::Base
      options_field_with_details :uses_weapons
      options_field_with_details :conceals_weapons
      options_field_with_details :conceals_drugs
      options_field_with_details :conceals_mobile_phone_or_other_items
      options_field_with_details :substance_supply
    end
  end
end
