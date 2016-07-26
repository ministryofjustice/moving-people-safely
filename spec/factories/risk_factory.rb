FactoryGirl.define do
  factory :risk do
    open_acct 'no'
    suicide 'no'
    rule_45 'no'
    csra 'no'
    verbal_abuse 'no'
    physical_abuse 'no'
    violent 'no'
    stalker_harasser_bully 'no'
    sex_offence 'no'
    non_association_markers 'no'
    current_e_risk 'no'
    escape_list 'no'
    other_escape_risk_info 'no'
    category_a 'no'
    restricted_status 'no'
    drugs 'no'
    alcohol 'no'
    conceals_weapons 'no'
    arson 'no'
    damage_to_property 'no'
    interpreter_required 'no'
    hearing_speach_sight 'no'
    can_read_and_write 'no'

    workflow_status { %w[ confirmed issued ].sample }

    trait :incomplete do
      conceals_weapons 'yes'
      workflow_status { %w[ incomplete needs_review unconfirmed ].sample }
    end
  end
end
