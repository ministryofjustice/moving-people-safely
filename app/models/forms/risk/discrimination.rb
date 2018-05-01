module Forms
  module Risk
    class Discrimination < Forms::Base
      optional_details_field :violence_to_staff
      optional_details_field :risk_to_females
      optional_details_field :homophobic
      optional_details_field :racist
      optional_details_field :discrimination_to_other_religions
      optional_details_field :other_violence_due_to_discrimination
    end
  end
end
