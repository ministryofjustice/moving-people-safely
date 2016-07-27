FactoryGirl.define do
  factory :healthcare do
    trait :no_allergies do
      allergies 'no'
      allergies_details nil
    end

    trait :with_allergies do
      allergies 'yes'
      allergies_details { Faker::Lorem.sentence }
    end

    trait :no_physical_issues do
      physical_issues 'no'
      physical_issues_details nil
    end

    trait :with_physical_issues do
      physical_issues 'yes'
      physical_issues_details { Faker::Lorem.sentence }
    end

    trait :no_mental_illness do
      mental_illness 'no'
      mental_illness_details nil
    end

    trait :with_mental_illness do
      mental_illness 'yes'
      mental_illness_details { Faker::Lorem.sentence }
    end

    trait :no_phobias do
      phobias 'no'
      phobias_details nil
    end

    trait :with_phobias do
      phobias 'yes'
      phobias_details { Faker::Lorem.sentence }
    end

    trait :no_personal_hygiene do
      personal_hygiene 'no'
      personal_hygiene_details nil
    end

    trait :with_personal_hygiene do
      personal_hygiene 'yes'
      personal_hygiene_details { Faker::Lorem.sentence }
    end

    trait :no_personal_care do
      personal_care 'no'
      personal_care_details nil
    end

    trait :with_personal_care do
      personal_care 'yes'
      personal_care_details { Faker::Lorem.sentence }
    end

    trait :no_dependencies do
      dependencies 'no'
      dependencies_details nil
    end

    trait :with_dependencies do
      dependencies 'yes'
      dependencies_details { Faker::Lorem.sentence }
    end

    trait :no_mpv do
      mpv 'no'
      mpv_details nil
    end

    trait :with_mpv do
      mpv 'yes'
      mpv_details { Faker::Lorem.sentence }
    end

    has_medications 'yes'
    medications { build_list :medication, rand(1..5) }

    workflow_status 'confirmed'

    healthcare_professional { Faker::Name.name }
    contact_number { Faker::PhoneNumber.cell_phone }

    trait :incomplete do
      workflow_status { %w[ incomplete needs_review unconfirmed ].sample }
    end

    trait :needs_review do
      workflow_status 'needs_review'
    end

    trait :without_medications do
      has_medications 'no'
    end

    ignore do
      %w[ allergies physical_issues mental_illness phobias personal_hygiene personal_care dependencies mpv ].each do |elem|
        send([ "no_#{elem}", "with_#{elem}" ].sample)
      end
    end
  end
end
