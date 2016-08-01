FactoryGirl.define do
  factory :detainee do
    forenames { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(80.years.ago, 20.years.ago) }
    gender { %w[ male female ].sample }
    nationalities 'American'
    pnc_number { rand(9999) }
    cro_number { rand(9999) }
    aliases { Faker::Name.name }
    prison_number do
        a = 3.times.map { ('A'..'Z').to_a.sample }
        b = 4.times.map { (0..9).to_a.sample }
        [a[0],b[0],b[1],b[2],b[3],a[1],a[2]].join
    end

    association :healthcare, factory: :healthcare, strategy: :build
    association :risk, factory: :risk, strategy: :build
    association :offences, factory: :offences, strategy: :build

    trait :with_incomplete_healthcare do
      association :healthcare, :incomplete, factory: :healthcare, strategy: :build
    end

    trait :with_incomplete_risk do
      association :risk, :incomplete, factory: :risk, strategy: :build
    end

    trait :with_incomplete_offences do
      association :offences, :incomplete, factory: :offences, strategy: :build
    end

    trait :with_multiples do
      association :healthcare, :with_medications, factory: :healthcare, strategy: :build
    end
  end
end
