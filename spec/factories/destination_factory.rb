require_relative '../support/fixture_data'

FactoryGirl.define do
  factory :destination do
    establishment { FixtureData.prison }
    must_return { %w[ must_return must_not_return ].sample }
    reasons { Faker::Lorem.paragraph }
  end
end
