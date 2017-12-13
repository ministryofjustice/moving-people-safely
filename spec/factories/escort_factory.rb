FactoryBot.define do
  factory :escort do
    prison_number do
      a = 3.times.map { ('A'..'Z').to_a.sample }
      b = 4.times.map { (0..9).to_a.sample }
      [a[0],b[0],b[1],b[2],b[3],a[1],a[2]].join
    end

    trait :with_detainee do
      association :detainee
    end

    trait :with_move do
      association :move
    end

    trait :with_expired_move do
      association :move, :expired
    end

    trait :with_complete_risk_assessment do
      association :risk, :confirmed
    end

    trait :with_complete_healthcare_assessment do
      association :healthcare, :confirmed
    end

    trait :with_complete_offences do
      association :offences_workflow, :confirmed
    end

    trait :with_incomplete_risk_assessment do
      association :risk, :incomplete
    end

    trait :with_incomplete_healthcare_assessment do
      association :healthcare, :incomplete
    end

    trait :completed do
      association :detainee
      association :move
      association :risk, :confirmed
      association :healthcare, :confirmed
      association :offences_workflow, :confirmed
    end

    trait :needs_review do
      association :detainee
      association :move
      association :offences_workflow, :needs_review
      association :risk, :needs_review
      association :healthcare, :needs_review
    end

    trait :issued do
      completed
      issued_at 1.day.ago.utc
      document { File.new("#{Rails.root}/spec/support/fixtures/pdf-per-document.pdf") }
    end

    trait :cancelled do
      completed
      cancelled_at 1.day.ago.utc
    end

    trait :expired do
      completed
      with_expired_move
    end
  end
end
