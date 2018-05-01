module Forms
  module Risk
    class Escape < Forms::Base
      optional_details_field :current_e_risk
      optional_details_field :previous_escape_attempts
      optional_field :escort_risk_assessment
      optional_field :escape_pack
    end
  end
end
