FactoryGirl.define do
  factory :risk do
    acct_status 'open'
    rule_45 'no'
    csra 'standard'
    victim_of_abuse 'no'
    high_profile 'no'
    violence_due_to_discrimination 'no'
    violence_to_staff 'no'
    violence_to_other_detainees 'no'
    violence_to_general_public 'no'
    controlled_unlock_required 'no'
    harassment 'no'
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
    arson 'no'
    other_risk 'no'

    trait :with_high_csra do
      csra 'high'
    end

    trait :incomplete do
      rule_45 'unknown'
      harassment 'unknown'
      conceals_weapons 'unknown'
    end
  end
end
