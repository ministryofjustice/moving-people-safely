module Forms
  module Risk
    class Escape < Forms::Base
      options_field_with_details :current_e_risk, if: :from_prison?
      options_field_with_details :previous_escape_attempts
      options_field :escort_risk_assessment, if: :from_prison?
      options_field :escape_pack, if: :from_prison?
    end
  end
end
