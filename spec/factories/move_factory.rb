require_relative '../support/fixture_data'

FactoryBot.define do
  factory :move do
    association :from_establishment, factory: :prison
    to { FixtureData.county_court }
    to_type 'magistrates_court'
    date { Date.current }
    not_for_release 'no'

    trait :active do
      date { 1.week.from_now }
    end

    trait :expired do
      date { 1.week.ago }
    end

    trait :with_form_attributes do
      to nil
      to_magistrates_court 'My magistrates court'
    end
  end
end
