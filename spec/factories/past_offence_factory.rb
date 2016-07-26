FactoryGirl.define do
  factory :past_offence do
    offence { Faker::Lorem.sentence }
  end
end
