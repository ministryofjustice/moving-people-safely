FactoryBot.define do
  factory :offences_workflow do
    status { :incomplete }

    trait :confirmed do
      status { :confirmed }
      association { :reviewer }, factory: :user
      reviewed_at { 1.day.ago }
    end

    trait :needs_review do
      status { :needs_review }
    end
  end
end
