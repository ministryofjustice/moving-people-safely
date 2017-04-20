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

    trait :without_assessments do
      risk { build_risk }
      healthcare { build_healthcare }
    end

    trait :with_multiples do
      association :healthcare, :with_medications, factory: :healthcare, strategy: :build
    end

    trait :with_no_offences do
      offences { build :offences, :empty_record }
    end

    trait :with_no_current_offences do
      association :offences, :with_no_current_offences, factory: :offences, strategy: :build
    end

    trait :with_incomplete_risk_assessment do
      association :risk, :incomplete, strategy: :build
    end
  end
end
