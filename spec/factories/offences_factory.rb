FactoryGirl.define do
  factory :offences do
    current_offences { build_list :current_offence, rand(1..5) }

    trait :empty_record do
      current_offences { [] }
    end

    trait :with_no_current_offences do
      current_offences { [] }
    end
  end
end
