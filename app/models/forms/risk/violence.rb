module Forms
  module Risk
    class Violence < Forms::Base
      optional_field :violence_due_to_discrimination, default: 'unknown'
      optional_checkbox :risk_to_females
      optional_checkbox :homophobic
      optional_checkbox_with_details :racist, :violence_due_to_discrimination
      optional_checkbox_with_details :other_violence_due_to_discrimination, :violence_due_to_discrimination
      reset attributes: %i[risk_to_females homophobic racist racist_details
                           other_violence_due_to_discrimination other_violence_due_to_discrimination_details],
            if_falsey: :violence_due_to_discrimination

      optional_field :violence_to_staff, default: 'unknown'
      optional_checkbox :violence_to_staff_custody
      optional_checkbox :violence_to_staff_community
      reset attributes: %i[violence_to_staff_custody violence_to_staff_community], if_falsey: :violence_to_staff

      optional_field :violence_to_other_detainees, default: 'unknown'
      optional_checkbox_with_details :co_defendant, :violence_to_other_detainees
      optional_checkbox_with_details :gang_member, :violence_to_other_detainees
      optional_checkbox_with_details :other_violence_to_other_detainees, :violence_to_other_detainees
      reset attributes: %i[co_defendant co_defendant_details gang_member
                           gang_member_details other_violence_to_other_detainees
                           other_violence_to_other_detainees_details],
            if_falsey: :violence_to_other_detainees

      optional_details_field :violence_to_general_public, default: 'unknown'
    end
  end
end
