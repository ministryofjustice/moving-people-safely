FactoryGirl.define do
  factory :healthcare do
    allergies 'no'
    physical_issues 'no'
    mental_illness 'no'
    personal_care 'no'
    dependencies 'no'
    mpv 'no'
    has_medications 'no'

    contact_number { Faker::PhoneNumber.cell_phone }
    status :incomplete

    trait :with_medications do
      has_medications 'yes'
      medications { build_list :medication, rand(1..5) }
    end

    trait :incomplete do
      physical_issues nil
    end

    trait :unconfirmed do
      status :unconfirmed
    end

    trait :confirmed do
      status :confirmed
    end

    trait :issued do
      status :issued
    end

    trait :needs_review do
      status :needs_review
    end
  end
end
