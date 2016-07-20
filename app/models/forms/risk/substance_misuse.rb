module Forms
  module Risk
    class SubstanceMisuse < Forms::Base
      optional_details_field :drugs
      optional_details_field :alcohol
    end
  end
end
