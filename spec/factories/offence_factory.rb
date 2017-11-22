FactoryBot.define do
  factory :offence do
    offence { Faker::Lorem.sentence }
    case_reference { ('A'..'Z').to_a.sample(10).join }
  end
end
