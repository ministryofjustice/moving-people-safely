FactoryGirl.define do
  factory :offences do
    release_date '15/09/2027'
    workflow_status 'complete'

    trait :incomplete do
      workflow_status 'incomplete'
    end
  end
end
