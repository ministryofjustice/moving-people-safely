FactoryGirl.define do
  factory :escort do
    association :detainee, factory: :detainee, strategy: :build
    association :move, factory: :move, strategy: :build
    association :healthcare, factory: :healthcare, strategy: :build
    association :risks, factory: :risks, strategy: :build
    association :offences, factory: :offences, strategy: :build

    trait :with_past_move do
      association :move, :past_move, factory: :move, strategy: :build
    end

    trait :with_future_move do
      association :move, :future_move, factory: :move, strategy: :build
    end
  end
end
