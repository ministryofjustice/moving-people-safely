FactoryBot.define do
  factory :escort do
    prison_number do
      a = 3.times.map { ('A'..'Z').to_a.sample }
      b = 4.times.map { (0..9).to_a.sample }
      [a[0],b[0],b[1],b[2],b[3],a[1],a[2]].join
    end

    pnc_number do
      [
        '%02d' % rand(99),
        '/',
        '%06d' % rand(999999),
        ('A'..'Z').to_a.sample
      ].join
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

    trait :from_prison do
      association :move, :from_prison
    end

    trait :from_police do
      association :move, :from_police
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

    offences { build_list :offence, rand(1..5) }

    trait :with_no_offences do
      offences { [] }
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

    trait :approved do
      association :approver, factory: :user
      approved_at 1.day.ago.utc
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

    trait :with_prison_not_for_release_reason do
      not_for_release 'yes'
      not_for_release_reason 'further_charges'
    end

    trait :with_police_not_for_release_reason do
      not_for_release 'yes'
      not_for_release_reason 'recall_to_prison'
    end
  end
end
