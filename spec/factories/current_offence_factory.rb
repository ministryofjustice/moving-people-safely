FactoryGirl.define do
  factory :current_offence do
    offence { Faker::Lorem.sentence }
    case_reference { ('A'..'Z').to_a.sample(10).join }
  end
end
