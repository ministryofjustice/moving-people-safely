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
    harassment 'no'
    hostage_taker 'no'
    intimidation 'no'
    sex_offence 'no'
    non_association_markers 'no'
    current_e_risk 'no'
    previous_escape_attempts 'no'
    category_a 'no'
    escape_pack 'no'
    escort_risk_assessment 'no'
    substance_supply 'no'
    substance_use 'no'
    conceals_weapons 'no'
    conceals_drugs 'no'
    conceals_mobile_phone_or_other_items 'no'
    arson 'no'
    damage_to_property 'no'
    interpreter_required 'no'
    hearing_speach_sight 'no'
    can_read_and_write 'no'

    trait :with_high_csra do
      csra 'high'
    end
  end
end
