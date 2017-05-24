FactoryGirl.define do
  factory :workflow do
    status :incomplete

    trait :confirmed do
      status :confirmed
    end

    trait :issued do
      status :issued
    end

    trait :needs_review do
      status :needs_review
    end
  end

  factory :move_workflow, parent: :workflow, class: 'MoveWorkflow' do
  end

  factory :offences_workflow, parent: :workflow, class: 'OffencesWorkflow' do
  end
end
