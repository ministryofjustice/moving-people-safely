require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Date.today }
    reason 'other'
    reason_details 'Has to move'
    has_destinations 'no'

    association :workflow, :incomplete, :move, factory: :workflow, strategy: :build

    trait :past_move do
      date { 1.week.ago }
    end

    trait :active do
      date { 1.week.from_now }
    end

    trait :confirmed do
      association :risk_workflow, :risk, :confirmed, factory: :workflow, strategy: :build
      association :healthcare_workflow, :healthcare, :confirmed, factory: :workflow, strategy: :build
      association :offences_workflow, :offences, :confirmed, factory: :workflow, strategy: :build
    end

    trait :with_destinations do
      has_destinations 'yes'
      destinations { build_list :destination, rand(1..5) }
    end

    trait :with_incomplete_risk_workflow do
      association :risk_workflow, :incomplete, :risk, factory: :workflow, strategy: :build
    end
  end
end
