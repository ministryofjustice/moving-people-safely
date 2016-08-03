module Forms
  module Risk
    class Violence < Forms::Base
      optional_field :violent
      reset attributes: %i[
        prison_staff prison_staff_details risk_to_females risk_to_females_details
        escort_or_court_staff escort_or_court_staff_details healthcare_staff
        healthcare_staff_details other_detainees other_detainees_details homophobic
        homophobic_details racist racist_details public_offence_related
        public_offence_related_details police police_details
      ], if_falsey: :violent

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
