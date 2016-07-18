FactoryGirl.define do
  factory :risks do
    open_acct 'No'
    suicide 'No'
    rule_45 'No'
    csra 'No'
    verbal_abuse 'No'
    physical_abuse 'No'
    violent 'No'
    stalker_harasser_bully 'No'
    sex_offence 'No'
    non_association_markers 'No'
    current_e_risk 'No'
    escape_list 'No'
    other_escape_risk_info 'No'
    category_a 'No'
    restricted_status 'No'
    drugs 'No'
    alcohol 'No'
    conceals_weapons 'No'
    arson 'No'
    damage_to_property 'No'
    interpreter_required 'No'
    hearing_speach_sight 'No'
    can_read_and_write 'No'

    workflow_status 'complete'

    trait :incomplete do
      conceals_weapons 'Yes'
      workflow_status 'incomplete'
    end
  end
end
