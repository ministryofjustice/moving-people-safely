FactoryGirl.define do
  factory :healthcare do
    allergies 'no'
    physical_issues 'no'
    mental_illness 'no'
    phobias 'no'
    personal_hygiene 'no'
    personal_care 'no'
    dependencies 'no'
    mpv 'no'
    has_medications 'no'
    workflow_status 'complete'

    trait :incomplete do
      allergies 'yes'
      workflow_status 'incomplete'
    end
  end
end
