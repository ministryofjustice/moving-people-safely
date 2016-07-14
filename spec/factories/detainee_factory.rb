FactoryGirl.define do
  factory :detainee do
    forenames { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(80.years.ago, 20.years.ago) }
    gender 'male'
    nationalities 'American'
    pnc_number '1234'
    cro_number '9876'
    aliases { Faker::Name.name }
    prison_number do
        a = 3.times.map { ('A'..'Z').to_a.sample }
        b = 4.times.map { (0..9).to_a.sample }
        [a[0],b[0],b[1],b[2],b[3],a[1],a[2]].join
    end
  end
end
