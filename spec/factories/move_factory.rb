require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Date.today }
    reason 'other'
    reason_details 'Has to move'

    association :workflow, :incomplete, :move, factory: :workflow, strategy: :build

    trait :issued do
      association :workflow, :issued, :move, factory: :workflow, strategy: :build
    end

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

    trait :with_incomplete_risk_workflow do
      association :risk_workflow, :incomplete, :risk, factory: :workflow, strategy: :build
    end
  end
end
