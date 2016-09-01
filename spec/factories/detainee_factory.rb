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

    trait :with_active_move do
      moves { build_list :move, 1, :active }
    end

    trait :with_completed_move do
      moves { build_list :move, 1, :issued }
    end

    trait :with_completed_considerations do
      after(:create) do |detainee, evaluator|
        %i[ risk healthcare offences ].each do |form_name|
          form = Considerations::FormFactory.new(detainee).(form_name)
          form.assign_attributes FixtureData.consideration(form_name)
          form.save!
        end
      end
    end
  end
end
