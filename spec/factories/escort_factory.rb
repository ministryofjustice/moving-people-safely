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
  end
end
