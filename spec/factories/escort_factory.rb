FactoryGirl.define do
  factory :escort do
    prison_number do
      a = 3.times.map { ('A'..'Z').to_a.sample }
      b = 4.times.map { (0..9).to_a.sample }
      [a[0],b[0],b[1],b[2],b[3],a[1],a[2]].join
    end

    trait :with_detainee do
      association :detainee
    end

    trait :with_move do
      association :move
    end

    trait :with_incomplete_risk_assessment do
      association :risk, :incomplete, strategy: :build
    end

    trait :with_incomplete_healthcare_assessment do
      association :healthcare, :incomplete, strategy: :build
    end

    trait :completed do
      association :detainee
      association :move, :confirmed
      association :risk
      association :healthcare
    end

    trait :issued do
      association :detainee
      association :move, :issued, :confirmed
      association :risk
      association :healthcare
    end
  end
end
