FactoryGirl.define do
  factory :escort do
    association :detainee, factory: :detainee, strategy: :build
    association :move, factory: :move, strategy: :build
    association :healthcare, factory: :healthcare, strategy: :build
    association :risk, factory: :risk, strategy: :build
    association :offences, factory: :offences, strategy: :build

    trait :with_past_move do
      association :move, :past_move, factory: :move, strategy: :build
    end

    trait :with_future_move do
      association :move, :future_move, factory: :move, strategy: :build
    end

    trait :with_incomplete_healthcare do
      association :healthcare, :incomplete, factory: :healthcare, strategy: :build
    end

    trait :with_incomplete_risk do
      association :risk, :incomplete, factory: :risk, strategy: :build
    end

    trait :with_incomplete_offences do
      association :offences, :incomplete, factory: :offences, strategy: :build
    end
  end
end
