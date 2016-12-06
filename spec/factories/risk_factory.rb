FactoryGirl.define do
  factory :risk do
    acct_status 'open'
    rule_45 'no'
    csra 'standard'
    verbal_abuse 'no'
    physical_abuse 'no'
    violent 'no'
    stalker_harasser_bully 'no'
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
      csra_details { Faker::Lorem.sentence }
    end
  end
end
