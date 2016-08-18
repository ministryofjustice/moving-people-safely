module Forms
  module Risk
    class SubstanceMisuse < Forms::Base
      optional_details_field :substance_supply
      optional_details_field :substance_use
    end
  end
end
