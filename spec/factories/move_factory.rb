require_relative '../support/fixture_data'

FactoryBot.define do
  factory :move do
    association :from_establishment, factory: :prison
    to { FixtureData.county_court }
    to_type { 'magistrates_court' }
    date { Date.current }
    not_for_release { 'no' }

    trait :active do
      date { 1.week.from_now }
    end

    trait :expired do
      date { 1.week.ago }
    end

    trait :from_police do
      association :from_establishment, factory: :police_custody
    end

    trait :from_prison do
      association :from_establishment, factory: :prison
    end

    trait :with_special_vehicle_details do
      require_special_vehicle { 'yes' }
      require_special_vehicle_details { 'special van' }
      other_transport_requirements { 'yes' }
      other_transport_requirements_details { 'other vehicle requirements' }
    end

    trait :with_child do
      travelling_with_child { 'yes' }
      child_full_name { Faker::Name.name }
      child_date_of_birth { Faker::Date.between(6.years.ago, 2.years.ago) }
    end
  end
end
