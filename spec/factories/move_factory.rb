require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Time.current.to_date }
    not_for_release 'no'

    trait :active do
      date { 1.week.from_now }
    end
  end
end
