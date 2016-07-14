FactoryGirl.define do
  factory :move do
    from { Data.prison }
    to { Data.county_court }
    date { Date.today }
    reason 'production_to_court'
    has_destinations 'no'

    trait :past_move do
      date { 1.week.ago }
    end
  end
end
