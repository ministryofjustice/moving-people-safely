require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Date.today }
    reason 'other'
    reason_details 'Has to move'
    has_destinations 'no'

    trait :past_move do
      date { 1.week.ago }
    end

    trait :future_move do
      date { 1.week.from_now }
    end

    trait :with_destinations do
      has_destinations 'yes'
      destinations { build_list :destination, rand(1..5) }
    end
  end
end
