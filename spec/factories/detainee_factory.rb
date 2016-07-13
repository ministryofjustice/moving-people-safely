FactoryGirl.define do
  factory :detainee do
    forenames { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(80.years.ago, 20.years.ago) }
    gender 'male'
    prison_number 'A1234BC'
    nationalities 'American'
    pnc_number '1234'
    cro_number '9876'
    aliases 'Donald duck'
  end
end
