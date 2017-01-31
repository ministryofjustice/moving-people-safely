require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Date.today }
    has_destinations 'no'

    association :move_workflow, :incomplete, strategy: :build

    trait :issued do
      association :move_workflow, :issued, strategy: :build
    end

    trait :past_move do
      date { 1.week.ago }
    end

    trait :active do
      date { 1.week.from_now }
    end

    trait :confirmed do
      association :risk_workflow, :confirmed, strategy: :build
      association :healthcare_workflow, :confirmed, strategy: :build
      association :offences_workflow, :confirmed, strategy: :build
    end

    trait :with_destinations do
      has_destinations 'yes'
      destinations { build_list :destination, rand(1..5) }
    end

    trait :with_incomplete_risk_workflow do
      association :risk_workflow, :incomplete, strategy: :build
    end
  end
end
