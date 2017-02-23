require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :destination do
    establishment { FixtureData.prison }
    must_return { %w[ must_return must_not_return ].sample }
    reasons { Faker::Lorem.paragraph }

    trait :must_return do
      must_return 'must_return'
    end

    trait :must_not_return do
      must_return 'must_not_return'
    end
  end
end
