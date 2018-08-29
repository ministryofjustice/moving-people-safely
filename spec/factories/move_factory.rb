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
  end
end
