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
    workflow_status 'confirmed'

    trait :incomplete do
      allergies 'yes'
      workflow_status { %w[ incomplete needs_review unconfirmed ].sample }
    end

    trait :with_medications do
      has_medications 'yes'
      medications { build_list :medication, rand(1..5) }
    end
  end
end
