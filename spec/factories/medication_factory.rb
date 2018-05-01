FactoryBot.define do
  factory :medication do
    description { Faker::Beer.name }
    administration "Take regularly"
    dosage "By mouth"
    when_given "Daily"
    carrier { %w[ escort prisoner ].sample }
  end
end
