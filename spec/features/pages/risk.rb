module Page
  class Risk < Base
    def expect_summary_page_with_completed_status
      within('.status-label--complete') do
        expect(page).to have_content('Complete')
      end
    end

    def complete_forms
      fill_in_risk_to_self
      fill_in_risk_from_others
      fill_in_violence
      fill_in_harassments
      fill_in_sex_offences
      fill_in_non_association_markers
      fill_in_security
      fill_in_substance_misuse
      fill_in_concealed_weapons
      fill_in_arson
      fill_in_communication
    end

    def fill_in_risk_to_self
      choose 'risk_to_self_open_acct_yes'
      choose 'risk_to_self_suicide_yes'
      fill_in 'risk_to_self[suicide_details]', with: 'Tried twice'
      save_and_continue
    end

    def fill_in_risk_from_others
      choose 'risk_from_others_rule_45_yes'
      fill_in 'risk_from_others[rule_45_details]', with: 'Details for Rule 45'
      choose 'risk_from_others_csra_high'
      fill_in 'risk_from_others[csra_details]', with: 'High CSRA'
      choose 'risk_from_others_verbal_abuse_yes'
      fill_in 'risk_from_others[verbal_abuse_details]', with: 'Details for verbal abuse'
      choose 'risk_from_others_physical_abuse_yes'
      fill_in 'risk_from_others[physical_abuse_details]', with: 'Details for physical abuse'
      save_and_continue
    end

    def fill_in_violence
      choose 'violence_violent_yes'
      check 'Prison staff'
      fill_in 'violence[prison_staff_details]', with: 'Details for violent to prison stuff'
      save_and_continue
    end

    def fill_in_harassments
      choose 'harassments_stalker_harasser_bully_yes'
      check 'Intimidator'
      fill_in 'harassments[intimidator_details]', with: 'Aggressive personality'
      save_and_continue
    end

    def fill_in_sex_offences
      choose 'sex_offences_sex_offence_yes'
      choose 'Under 18'
      fill_in 'sex_offences[sex_offence_details]', with: '17 years old'
      save_and_continue
    end

    def fill_in_security
      choose 'security_current_e_risk_yes'
      fill_in 'security[current_e_risk_details]', with: 'There is current E risk'
      choose 'security_escape_list_yes'
      fill_in 'security[escape_list_details]', with: 'Tried 2 times'
      choose 'security_other_escape_risk_info_yes'
      fill_in 'security[other_escape_risk_info_details]', with: 'Used a hammer'
      choose 'security_category_a_yes'
      fill_in 'security[category_a_details]', with: 'Category A information'
      choose 'security_restricted_status_yes'
      fill_in 'security[restricted_status_details]', with: 'Restricted status details info'
      check 'Escape pack'
      check 'Escape risk assessment'
      check 'Cuffing protocol'
      save_and_continue
    end

    def fill_in_non_association_markers
      choose 'non_association_markers_non_association_markers_yes'
      fill_in 'non_association_markers[non_association_markers_details]', with: 'Prisoner A1234BC and Z9876XY'
      save_and_continue
    end

    def fill_in_substance_misuse
      choose 'substance_misuse_drugs_yes'
      fill_in 'substance_misuse[drugs_details]', with: 'Heroin'
      choose 'substance_misuse_alcohol_yes'
      fill_in 'substance_misuse[alcohol_details]', with: 'Lots of beer'
      save_and_continue
    end

    def fill_in_concealed_weapons
      choose 'concealed_weapons_conceals_weapons_yes'
      fill_in 'concealed_weapons[conceals_weapons_details]', with: 'Guns and rifles'
      save_and_continue
    end

    def fill_in_arson
      choose 'arson_arson_yes'
      choose 'arson_arson_value_index_offence'
      fill_in 'arson[arson_details]', with: 'Burnt several houses'
      choose 'arson_damage_to_property_no'
      save_and_continue
    end

    def fill_in_communication
      choose 'communication_interpreter_required_yes'
      fill_in 'communication[language]', with: 'German'
      choose 'communication_hearing_speach_sight_yes'
      fill_in 'communication[hearing_speach_sight_details]', with: 'Blind'
      choose 'communication_can_read_and_write_yes'
      fill_in 'communication[can_read_and_write_details]', with: 'Can only read'
      save_and_continue
    end
  end
end
