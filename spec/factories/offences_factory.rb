FactoryGirl.define do
  factory :offences do
    release_date '15/09/2027'
    workflow_status 'confirmed'

    current_offences { build_list :current_offence, rand(1..5) }

    has_past_offences 'yes'
    past_offences { build_list :past_offence, rand(1..5) }

    trait :incomplete do
      workflow_status 'incomplete'
    end
  end
end
