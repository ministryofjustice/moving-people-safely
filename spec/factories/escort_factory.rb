FactoryGirl.define do
  factory :escort do
    association :detainee, factory: :detainee, strategy: :build
    association :move, factory: :move, strategy: :build
    association :offences, factory: :offences, strategy: :build

    trait :with_past_move do
      association :move, :past_move, factory: :move, strategy: :build
    end
  end
end
