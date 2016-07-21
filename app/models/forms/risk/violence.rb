module Forms
  module Risk
    class Violence < Forms::Base
      optional_field :violent
      optional_checkbox :prison_staff, :violent
      optional_checkbox :risk_to_females, :violent
      optional_checkbox :escort_or_court_staff, :violent
      optional_checkbox :healthcare_staff, :violent
      optional_checkbox :other_detainees, :violent
      optional_checkbox :homophobic, :violent
      optional_checkbox :racist, :violent
      optional_checkbox :public_offence_related, :violent
      optional_checkbox :police, :violent
    end
  end
end
