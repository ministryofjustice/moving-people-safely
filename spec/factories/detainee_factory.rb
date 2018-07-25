FactoryBot.define do
  factory :detainee do
    prison_number do
      a = 3.times.map { ('A'..'Z').to_a.sample }
      b = 4.times.map { (0..9).to_a.sample }
      [a[0],b[0],b[1],b[2],b[3],a[1],a[2]].join
    end

    pnc_number do
      [
        '%02d' % rand(99),
        '/',
        '%06d' % rand(999999),
        ('A'..'Z').to_a.sample
      ].join
    end

    forenames { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(80.years.ago, 20.years.ago) }
    gender { %w[ male female ].sample }
    nationalities { 'American' }
    cro_number { rand(9999) }
    aliases { Faker::Name.name }
    interpreter_required { 'yes' }
    interpreter_required_details { 'English-American translator' }
    peep { 'yes' }
    peep_details { 'Prisoner has a broken leg' }
    security_category 'Cat A'
    diet { %w[ gluten_free vegan ].sample.humanize }
    language { %w[ english italian spanish ].sample.humanize }
  end
end
