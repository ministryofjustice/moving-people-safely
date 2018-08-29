FactoryBot.define do
  factory :offences_workflow do
    status { :incomplete }

    trait :confirmed do
      status { :confirmed }
    end

    trait :needs_review do
      status { :needs_review }
    end
  end
end
