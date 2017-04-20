require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Date.today }
    not_for_release 'no'
    has_destinations 'no'

    association :move_workflow, :incomplete, strategy: :build

    trait :issued do
      association :move_workflow, :issued, strategy: :build
    end

    trait :active do
      date { 1.week.from_now }
    end

    trait :confirmed do
      association :risk_workflow, :confirmed, strategy: :build
      association :healthcare_workflow, :confirmed, strategy: :build
      association :offences_workflow, :confirmed, strategy: :build
    end

    trait :needs_review do
      association :risk_workflow, :needs_review, strategy: :build
      association :healthcare_workflow, :needs_review, strategy: :build
      association :offences_workflow, :needs_review, strategy: :build
    end

    trait :with_complete_risk_workflow do
      association :risk_workflow, :confirmed, strategy: :build
    end

    trait :with_complete_healthcare_workflow do
      association :healthcare_workflow, :confirmed, strategy: :build
    end

    trait :with_complete_offences_workflow do
      association :offences_workflow, :confirmed, strategy: :build
    end

    trait :with_destinations do
      has_destinations 'yes'
      destinations { build_list :destination, rand(1..5) }
    end

    trait :with_incomplete_risk_workflow do
      association :risk_workflow, :incomplete, strategy: :build
    end

    trait :with_incomplete_healthcare_workflow do
      association :healthcare_workflow, :incomplete, strategy: :build
    end

    trait :with_incomplete_offences_workflow do
      association :offences_workflow, :incomplete, strategy: :build
    end
  end
end
