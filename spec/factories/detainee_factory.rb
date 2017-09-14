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

    offences { build_list :offence, rand(1..5) }

    trait :with_no_offences do
      offences { [] }
    end
  end
end
