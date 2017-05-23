FactoryGirl.define do
  factory :healthcare do
    allergies 'no'
    physical_issues 'no'
    mental_illness 'no'
    personal_care 'no'
    dependencies 'no'
    mpv 'no'
    has_medications 'no'

    healthcare_professional { Faker::Name.name }
    contact_number { Faker::PhoneNumber.cell_phone }

    trait :with_medications do
      has_medications 'yes'
      medications { build_list :medication, rand(1..5) }
    end

    trait :incomplete do
      healthcare_professional nil
      contact_number nil
    end
  end
end
