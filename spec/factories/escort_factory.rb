FactoryGirl.define do
  factory :escort do
    association :detainee, factory: :detainee, strategy: :build
    association :move, factory: :move, strategy: :build
    association :healthcare, factory: :healthcare, strategy: :build
    association :risk, factory: :risk, strategy: :build
    association :offences, factory: :offences, strategy: :build
    workflow_status 'confirmed'

    trait :with_past_move do
      association :move, :past_move, factory: :move, strategy: :build
    end

    trait :with_future_move do
      association :move, :future_move, factory: :move, strategy: :build
    end

    trait :with_incomplete_healthcare do
      association :healthcare, :incomplete, factory: :healthcare, strategy: :build
      workflow_status 'not_started'
    end

    trait :with_incomplete_risk do
      association :risk, :incomplete, factory: :risk, strategy: :build
      workflow_status 'not_started'
    end

    trait :with_incomplete_offences do
      association :offences, :incomplete, factory: :offences, strategy: :build
      workflow_status 'not_started'
    end

    trait :previously_issued do
      workflow_status 'issued'
    end

    trait :with_multiples do
      association :move, :with_destinations, factory: :move, strategy: :build
      association :healthcare, :with_medications, factory: :healthcare, strategy: :build
    end
  end
end
