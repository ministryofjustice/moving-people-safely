FactoryGirl.define do
  factory :workflow do
    status :not_started

    trait :incomplete do
      status :incomplete
    end

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

  factory :risk_workflow, parent: :workflow, class: 'RiskWorkflow' do
  end

  factory :healthcare_workflow, parent: :workflow, class: 'HealthcareWorkflow' do
  end

  factory :offences_workflow, parent: :workflow, class: 'OffencesWorkflow' do
  end
end
