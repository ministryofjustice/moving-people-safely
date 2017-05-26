require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :move do
    from { FixtureData.prison }
    to { FixtureData.county_court }
    date { Date.today }
    not_for_release 'no'
    has_destinations 'no'

    association :move_workflow, strategy: :build

    trait :issued do
      association :move_workflow, :issued, strategy: :build
    end

    trait :active do
      date { 1.week.from_now }
    end

    trait :with_destinations do
      has_destinations 'yes'
      destinations { build_list :destination, rand(1..5) }
    end
  end
end
