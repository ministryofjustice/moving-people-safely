FactoryGirl.define do
  factory :detainee do
    forenames 'Donald'
    surname 'Trump'
    date_of_birth Date.civil(1946, 6, 14)
    gender 'male'
    prison_number 'A1234BC'
    nationalities 'American'
    pnc_number '1234'
    cro_number '9876'
    aliases 'Donald duck'
  end
end
