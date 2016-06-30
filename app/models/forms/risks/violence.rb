module Forms
  module Risks
    class Violence < Forms::Base
      optional_field :violent
      optional_checkbox :prison_staff
      optional_checkbox :risk_to_females
      optional_checkbox :escort_or_court_staff
      optional_checkbox :healthcare_staff
      optional_checkbox :other_detainees
      optional_checkbox :homophobic
      optional_checkbox :racist
      optional_checkbox :public_offence_related
      optional_checkbox :police
    end
  end
end
