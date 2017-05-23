FactoryGirl.define do
  factory :medication do
    description { Faker::Beer.name }
    administration "Take regularly"
    carrier { %w[ escort prisoner ].sample }
  end
end

