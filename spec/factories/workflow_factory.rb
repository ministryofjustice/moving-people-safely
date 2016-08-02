FactoryGirl.define do
  factory :workflow do
    status 0

    trait :incomplete do
      status 2
    end

    trait :risk do
      type 'risk'
    end

    trait :move do
      type 'move'
    end

    trait :healthcare do
      type 'healthcare'
    end

    trait :offences do
      type 'offences'
    end

    trait :confirmed do
      status 4
    end

    trait :issued do
      status 5
    end
  end
end
