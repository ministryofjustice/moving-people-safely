# frozen_string_literal: true

module Forms
  module Risk
    class Discrimination < Forms::Base
      options_field_with_details :violence_to_staff
      options_field_with_details :risk_to_females
      options_field_with_details :homophobic
      options_field_with_details :racist
      options_field_with_details :discrimination_to_other_religions
      options_field_with_details :other_violence_due_to_discrimination
    end
  end
end
