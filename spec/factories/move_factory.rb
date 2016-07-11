FactoryGirl.define do
  factory :move do
    from 'HMP Bedford'
    to 'Alcatraz'
    date { 3.days.from_now }
    reason 'production_to_court'
    has_destinations 'no'

    trait :past_move do
      date { 1.week.ago }
    end
  end
end
