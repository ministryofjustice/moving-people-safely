module Page
  class Risk < Base
    def expect_summary_page_with_completed_status
      within('.status-label--complete') do
        expect(page).to have_content('Complete')
      end
    end

    def complete_forms(risk)
      @risk = risk
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
      fill_in_optional_details('Open or recent ACCT?', @risk.open_acct, @risk.open_acct_details)
      fill_in_optional_details('Risk of suicide or self-harm?', @risk.suicide, @risk.suicide_details)
      save_and_continue
    end

    def fill_in_risk_from_others
      fill_in_optional_details('Rule 45?', @risk.rule_45, @risk.rule_45_details)
      fill_in_optional_details('CSRA?', @risk.csra, @risk.csra_details)
      fill_in_optional_details('Is the detainee at risk of verbal abuse from others?', @risk.verbal_abuse, @risk.verbal_abuse_details)
      fill_in_optional_details('Is the detainee at risk of physical abuse from others?', @risk.physical_abuse, @risk.physical_abuse_details)
      save_and_continue
    end

    def fill_in_violence
      if @risk.violent == 'yes'
        choose 'violence_violent_yes'
        fill_in_checkbox_with_details('Prison staff', @risk.prison_staff, @risk.prison_staff_details)
        fill_in_checkbox_with_details('Risk to females', @risk.risk_to_females, @risk.risk_to_females_details)
        fill_in_checkbox_with_details('Escort or court staff', @risk.escort_or_court_staff, @risk.escort_or_court_staff_details)
        fill_in_checkbox_with_details('Healthcare staff', @risk.healthcare_staff, @risk.healthcare_staff_details)
        fill_in_checkbox_with_details('Other detainees', @risk.other_detainees, @risk.other_detainees_details)
        fill_in_checkbox_with_details('Homophobic', @risk.homophobic, @risk.homophobic_details)
        fill_in_checkbox_with_details('Racist', @risk.racist, @risk.racist_details)
        fill_in_checkbox_with_details('Public offence related', @risk.public_offence_related, @risk.public_offence_related_details)
        fill_in_checkbox_with_details('Police', @risk.police, @risk.police_details)
      else
        choose 'violence_violent_no'
      end
      save_and_continue
    end

    def fill_in_harassments
      if @risk.stalker_harasser_bully == 'yes'
        choose 'harassments_stalker_harasser_bully_yes'
        fill_in_checkbox_with_details('Hostage taker', @risk.hostage_taker, @risk.hostage_taker_details)
        fill_in_checkbox_with_details('Stalker', @risk.stalker, @risk.stalker_details)
        fill_in_checkbox_with_details('Harasser', @risk.harasser, @risk.harasser_details)
        fill_in_checkbox_with_details('Intimidator', @risk.intimidator, @risk.intimidator_details)
        fill_in_checkbox_with_details('Bully', @risk.bully, @risk.bully_details)
      else
        choose 'harassments_stalker_harasser_bully_no'
      end
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
      choose 'arson_arson_value_high'
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
