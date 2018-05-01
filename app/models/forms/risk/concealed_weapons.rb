module Forms
  module Risk
    class ConcealedWeapons < Forms::Base
      optional_details_field :uses_weapons
      optional_details_field :conceals_weapons
      optional_details_field :conceals_drugs
      optional_details_field :conceals_mobile_phone_or_other_items
      optional_field :substance_supply
    end
  end
end
