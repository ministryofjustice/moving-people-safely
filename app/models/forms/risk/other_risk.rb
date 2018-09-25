module Forms
  module Risk
    class OtherRisk < Forms::Base
      options_field_with_details :pnc_warnings, if: :from_police?
      options_field_with_details :other_risk
    end
  end
end
