FactoryBot.define do
  factory :must_not_return_detail do
    establishment { Faker::Beer.name }
    establishment_details "Does not like it"
  end
end
