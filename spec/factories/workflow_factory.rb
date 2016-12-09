FactoryGirl.define do
  factory :workflow do
    status 0

    trait :incomplete do
      status 2
    end

    trait :confirmed do
      status 4
    end

    trait :issued do
      status 5
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
