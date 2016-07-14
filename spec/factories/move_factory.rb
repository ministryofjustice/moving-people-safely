require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Date.today }
    reason 'production_to_court'
    has_destinations 'no'

    trait :past_move do
      date { 1.week.ago }
    end

    trait :future_move do
      date { 1.week.from_now }
    end
  end
end
