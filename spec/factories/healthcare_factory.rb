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
    healthcare_professional { Faker::Name.name }
    contact_number { Faker::PhoneNumber.cell_phone }

    workflow_status 'confirmed'

    trait :incomplete do
      workflow_status { %w[ incomplete needs_review unconfirmed ].sample }
    end

    trait :needs_review do
      workflow_status 'needs_review'
    end

    trait :with_medications do
      has_medications 'yes'
      medications { build_list :medication, rand(1..5) }
    end

    trait :with_random_data do
      allergies { %w[ no yes ].sample }
      allergies_details { allergies == 'yes' ? Faker::Lorem.sentence : nil }
      physical_issues { %w[ no yes ].sample }
      physical_issues_details { physical_issues == 'yes' ? Faker::Lorem.sentence : nil }
      mental_illness { %w[ no yes ].sample }
      mental_illness_details { mental_illness == 'yes' ? Faker::Lorem.sentence : nil }
      phobias { %w[ no yes ].sample }
      phobias_details { phobias == 'yes' ? Faker::Lorem.sentence : nil }
      personal_hygiene { %w[ no yes ].sample }
      personal_hygiene_details { personal_hygiene == 'yes' ? Faker::Lorem.sentence : nil }
      personal_care { %w[ no yes ].sample }
      personal_care_details { personal_care == 'yes' ? Faker::Lorem.sentence : nil }
      dependencies { %w[ no yes ].sample }
      dependencies_details { dependencies == 'yes' ? Faker::Lorem.sentence : nil }
      mpv { %w[ no yes ].sample }
      mpv_details { mpv == 'yes' ? Faker::Lorem.sentence : nil }
    end
  end
end
