class CreateRisks < ActiveRecord::Migration[5.0]
  def change
    create_table :risks, id: :uuid do |t|
      t.uuid   :escort_id
      t.string :open_acct, default: 'unknown'
      t.text   :open_acct_details
      t.string :suicide, default: 'unknown'
      t.text   :suicide_details
      t.string :rule_45, default: 'unknown'
      t.text   :rule_45_details
      t.string :csra, default: 'unknown'
      t.text   :csra_details
      t.string :verbal_abuse, default: 'unknown'
      t.text   :verbal_abuse_details
      t.string :physical_abuse, default: 'unknown'
      t.text   :physical_abuse_details
      t.string :violent, default: 'unknown'
      t.boolean :prison_staff
      t.text   :prison_staff_details
      t.boolean :risk_to_females
      t.text   :risk_to_females_details
      t.boolean :escort_or_court_staff
      t.text   :escort_or_court_staff_details
      t.boolean :healthcare_staff
      t.text   :healthcare_staff_details
      t.boolean :other_detainees
      t.text   :other_detainees_details
      t.boolean :homophobic
      t.text   :homophobic_details
      t.boolean :racist
      t.text   :racist_details
      t.boolean :public_offence_related
      t.text   :public_offence_related_details
      t.boolean :police
      t.text   :police_details
      t.string :hostage_taker_stalker_harasser, default: 'unknown'
      t.boolean :hostage_taker
      t.boolean :stalker
      t.boolean :harasser
      t.boolean :intimidation
      t.boolean :bullying
      t.string :sex_offence, default: 'unknown'
      t.string :sex_offence_victim
      t.text   :sex_offence_details
      t.string :non_association, default: 'unknown'
      t.string :current_e_risk, default: 'unknown'
      t.text   :current_e_risk_details
      t.string :escape_list, default: 'unknown'
      t.text   :escape_list_details
      t.string :other_escape_risk_info, default: 'unknown'
      t.text   :other_escape_risk_info_details
      t.string :category_a, default: 'unknown'
      t.text   :category_a_details
      t.string :restricted_status, default: 'unknown'
      t.text   :restricted_status_details
      t.boolean :escape_pack
      t.boolean :escape_risk_assessment
      t.boolean :cuffing_protocol
      t.string :drugs, default: 'unknown'
      t.text   :drugs_details
      t.string :alcohol, default: 'unknown'
      t.text   :alcohol_details
      t.string :conceals_weapons, default: 'unknown'
      t.text   :conceals_weapons_details
      t.string :arson, default: 'unknown'
      t.string :arson_value
      t.text   :arson_details
      t.string :damage_to_property, default: 'unknown'
      t.text   :damage_to_property_details
      t.string :interpreter_required, default: 'unknown'
      t.text   :interpreter_required_details
      t.string :hearing_speach_sight, default: 'unknown'
      t.text   :hearing_speach_sight_details
      t.string :can_read_and_write, default: 'unknown'
      t.text   :can_read_and_write_details
    end
  end
end
