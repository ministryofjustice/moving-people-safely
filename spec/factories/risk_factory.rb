FactoryGirl.define do
  factory :risk do
    acct_status 'open'
    rule_45 'no'
    csra 'standard'
    high_profile 'no'
    risk_to_females 'no'
    homophobic 'no'
    racist 'no'
    discrimination_to_other_religions 'no'
    other_violence_due_to_discrimination 'no'
    violence_to_staff 'no'
    violence_to_other_detainees 'no'
    violence_to_general_public 'no'
    controlled_unlock_required 'no'
    hostage_taker 'no'
    intimidation 'no'
    sex_offence 'no'
    current_e_risk 'no'
    previous_escape_attempts 'no'
    category_a 'no'
    escape_pack 'no'
    escort_risk_assessment 'no'
    substance_supply 'no'
    conceals_weapons 'no'
    conceals_drugs 'no'
    conceals_mobile_phone_or_other_items 'no'
    uses_weapons 'no'
    arson 'no'
    must_return 'no'
    must_not_return 'no'
    other_risk 'no'
    status :incomplete

    trait :with_high_csra do
      csra 'high'
    end

    trait :incomplete do
      rule_45 'unknown'
      conceals_weapons 'unknown'
    end

    trait :unconfirmed do
      status :unconfirmed
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
end
