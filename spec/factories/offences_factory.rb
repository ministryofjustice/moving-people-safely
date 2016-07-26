FactoryGirl.define do
  factory :offences do
    release_date '15/09/2027'
    workflow_status 'complete'

    current_offences { build_list :current_offence, 2 }

    has_past_offences 'yes'
    past_offences { build_list :past_offence, 3 }

    trait :incomplete do
      workflow_status 'incomplete'
    end
  end
end
