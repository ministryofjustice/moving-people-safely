FactoryBot.define do
  factory :escort do
    prison_number do
      a = 3.times.map { ('A'..'Z').to_a.sample }
      b = 4.times.map { (0..9).to_a.sample }
      [a[0],b[0],b[1],b[2],b[3],a[1],a[2]].join
    end

    forenames { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(80.years.ago, 20.years.ago) }
    gender { %w[ male female ].sample }
    nationalities 'American'
    pnc_number { rand(9999) }
    cro_number { rand(9999) }
    aliases { Faker::Name.name }
    interpreter_required { 'yes' }
    peep { 'yes' }
    peep_details { 'Prisoner has a broken leg' }
    diet { %w[ gluten_free vegan ].sample.humanize }
    language { %w[ english italian spanish ].sample.humanize }

    association :from_establishment, factory: :prison
    date { Date.current }
    to { FixtureData.county_court }
    to_type 'magistrates_court'
    not_for_release 'no'

    trait :active do
      date { 1.week.from_now }
    end

    trait :expired do
      date { 1.week.ago }
    end

    trait :with_form_attributes do
      to nil
      to_magistrates_court 'My magistrates court'
    end

    trait :with_complete_risk_assessment do
      association :risk, :confirmed
    end

    trait :with_complete_healthcare_assessment do
      association :healthcare, :confirmed
    end

    trait :with_complete_offences do
      association :offences_workflow, :confirmed
    end

    trait :with_incomplete_risk_assessment do
      association :risk, :incomplete
    end

    trait :with_incomplete_healthcare_assessment do
      association :healthcare, :incomplete
    end

    offences { build_list :offence, rand(1..5) }

    trait :with_no_offences do
      offences { [] }
    end

    trait :completed do
      association :risk, :confirmed
      association :healthcare, :confirmed
      association :offences_workflow, :confirmed
    end

    trait :needs_review do
      association :offences_workflow, :needs_review
      association :risk, :needs_review
      association :healthcare, :needs_review
    end

    trait :issued do
      completed
      issued_at 1.day.ago.utc
      document { File.new("#{Rails.root}/spec/support/fixtures/pdf-per-document.pdf") }
    end

    trait :cancelled do
      completed
      cancelled_at 1.day.ago.utc
    end

    trait :expired do
      completed
      expired
    end
  end
end
