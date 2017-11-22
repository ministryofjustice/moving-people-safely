FactoryBot.define do
  factory :must_not_return_detail, class: Hash do
    establishment { Faker::Beer.name }
    establishment_details "Does not like it"

    initialize_with { attributes }
  end

  factory :medication, class: Hash do
    description { Faker::Beer.name }
    administration "Take regularly"
    dosage "By mouth"
    when_given "Daily"
    carrier { %w[ escort prisoner ].sample }

    initialize_with { attributes }
  end
end
