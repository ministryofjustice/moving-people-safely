FactoryGirl.define do
  factory :escort do
    association :offences, factory: :offences, strategy: :build
  end
end
