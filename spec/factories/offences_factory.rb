FactoryGirl.define do
  factory :offences do
    current_offences { build_list :current_offence, rand(1..5) }

    has_past_offences 'yes'
    past_offences { build_list :past_offence, rand(1..5) }

    trait :empty_record do
      has_past_offences 'unknown'
      current_offences { [] }
      past_offences { [] }
    end

    trait :with_no_current_offences do
      current_offences { [] }
    end

    trait :with_no_past_offences do
      has_past_offences 'no'
      past_offences { [] }
    end
  end
end
