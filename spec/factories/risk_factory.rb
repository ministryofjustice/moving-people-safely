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
    category_a 'no'
    restricted_status 'no'
    escape_pack false
    escape_risk_assessment false
    cuffing_protocol false
    substance_supply 'no'
    substance_use 'no'
    conceals_weapons 'no'
    arson 'no'
    damage_to_property 'no'
    interpreter_required 'no'
    hearing_speach_sight 'no'
    can_read_and_write 'no'

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
