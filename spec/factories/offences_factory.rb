FactoryGirl.define do
  factory :offences do
    release_date '15/09/2027'

    current_offences { build_list :current_offence, rand(1..5) }

    has_past_offences 'yes'
    past_offences { build_list :past_offence, rand(1..5) }

    trait :empty_record do
      release_date nil
      has_past_offences 'unknown'
      current_offences { [] }
      past_offences { [] }
    end

    trait :with_no_current_offences do
      current_offences { [] }
    end
  end
end
