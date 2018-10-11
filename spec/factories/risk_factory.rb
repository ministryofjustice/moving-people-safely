FactoryBot.define do
  factory :risk do
    acct_status { 'open' }
    self_harm { 'no' }

    csra { 'standard' }
    rule_45 { 'no' }
    vulnerable_prisoner { 'no' }

    controlled_unlock { 'no' }
    high_profile { 'no' }
    pnc_warnings { 'no' }

    intimidation_public { 'no' }
    intimidation_prisoners { 'no' }
    violent_or_dangerous { 'no' }
    gang_member { 'no' }

    violence_to_staff { 'no' }
    risk_to_females { 'no' }
    homophobic { 'no' }
    racist { 'no' }
    discrimination_to_other_religions { 'no' }
    other_violence_due_to_discrimination { 'no' }

    current_e_risk { 'no' }
    previous_escape_attempts { 'no' }
    escape_pack { 'no' }
    escort_risk_assessment { 'no' }

    hostage_taker { 'no' }

    sex_offence { 'no' }

    conceals_weapons { 'no' }
    uses_weapons { 'no' }
    conceals_drugs { 'no' }
    conceals_mobile_phone_or_other_items { 'no' }

    substance_supply { 'no' }

    arson { 'no' }

    must_return { 'no' }
    has_must_not_return_details { 'no' }

    other_risk { 'no' }

    status { :incomplete }

    trait :with_high_csra do
      csra { 'high' }
    end

    trait :from_police do
      csra { 'no' }
    end

    trait :incomplete do
      rule_45 { nil }
      conceals_weapons { nil }
    end

    trait :unconfirmed do
      status { :unconfirmed }
    end

    trait :confirmed do
      status { :confirmed }
      association :reviewer, factory: :user
      reviewed_at { 1.day.ago }
    end

    trait :issued do
      status { :issued }
    end

    trait :needs_review do
      status { :needs_review }
    end
  end
end
