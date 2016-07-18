FactoryGirl.define do
  factory :healthcare do
    allergies 'No'
    physical_issues 'No'
    mental_illness 'No'
    phobias 'No'
    personal_hygiene 'No'
    personal_care 'No'
    dependencies 'No'
    mpv 'No'
    has_medications 'No'
    workflow_status 'complete'

    trait :incomplete do
      allergies 'Yes'
      workflow_status 'incomplete'
    end
  end
end
