FactoryGirl.define do
  factory :workflow do
    status 0

    trait :incomplete do
      status 2
    end

    trait :risk do
      type 'risk'
    end
  end
end
