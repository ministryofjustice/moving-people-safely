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
    hearing_speech_sight_issues 'no'
    reading_writing_issues 'no'

    healthcare_professional { Faker::Name.name }
    contact_number { Faker::PhoneNumber.cell_phone }

    trait :with_medications do
      has_medications 'yes'
      medications { build_list :medication, rand(1..5) }
    end
  end
end
