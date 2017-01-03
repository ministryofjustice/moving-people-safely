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
      fill_in_hostage_taker
      fill_in_harassments
      fill_in_sex_offences
      fill_in_security
      fill_in_substance_misuse
      fill_in_concealed_weapons
      fill_in_arson
    end

    def fill_in_risk_to_self
      fill_in_optional_details("Detainee's most recent ACCT status", @risk, :acct_status)
      save_and_continue
    end

    def fill_in_risk_from_others
      fill_in_optional_details('Rule 45', @risk, :rule_45)
      fill_in_optional_details('CSRA', @risk, :csra)
      fill_in_optional_details('Detainee a victim or possible victim of abuse in prison', @risk, :victim_of_abuse)
      fill_in_optional_details('Detainee of high public interest', @risk, :high_profile)
      save_and_continue
    end

    def fill_in_violence
      fill_in_violence_due_to_discrimination
      fill_in_violence_to_staff
      fill_in_violence_to_other_detainees
      fill_in_violence_to_general_public
      save_and_continue
    end

    def fill_in_violence_due_to_discrimination
      if @risk.violence_due_to_discrimination == 'yes'
        choose 'violence_violence_due_to_discrimination_yes'
        check 'Risk to females'
        check 'Homosexuals'
        fill_in_checkbox_with_details('Racist', @risk, :racist)
        fill_in_checkbox_with_details('Other', @risk, :other_violence_due_to_discrimination)
      else
        choose 'violence_violence_due_to_discrimination_no'
      end
    end

    def fill_in_violence_to_staff
      if @risk.violence_to_staff == 'yes'
        choose 'violence_violence_to_staff_yes'
        check 'Staff custody'
        check 'Staff community'
      else
        choose 'violence_violence_to_staff_no'
      end
    end

    def fill_in_violence_to_other_detainees
      if @risk.violence_to_other_detainees == 'yes'
        choose 'violence_violence_to_other_detainees_yes'
        fill_in_checkbox_with_details('Co-defendant', @risk, :co_defendant)
        fill_in_checkbox_with_details('Gang member', @risk, :gang_member)
        fill_in_checkbox_with_details('Other known conflicts', @risk, :other_violence_to_other_detainees)
      else
        choose 'violence_violence_to_other_detainees_no'
      end
    end

    def fill_in_violence_to_general_public
      if @risk.violence_to_general_public == 'yes'
        choose 'violence_violence_to_general_public_yes'
        fill_in 'violence_violence_to_general_public_details', with: @risk.violence_to_general_public_details
      else
        choose 'violence_violence_to_general_public_no'
      end
    end

    def fill_in_hostage_taker
      if @risk.hostage_taker == 'yes'
        choose 'hostage_taker_hostage_taker_yes'
        fill_in_staff_hostage_taker
        fill_in_prisoners_hostage_taker
        fill_in_public_hostage_taker
      else
        choose 'hostage_taker_hostage_taker_no'
      end
      save_and_continue
    end

    def fill_in_staff_hostage_taker
      if @risk.staff_hostage_taker
        check 'hostage_taker_staff_hostage_taker'
        fill_in 'hostage_taker_date_most_recent_staff_hostage_taker_incident', with: @risk.date_most_recent_staff_hostage_taker_incident
      end
    end

    def fill_in_prisoners_hostage_taker
      if @risk.prisoners_hostage_taker
        check 'hostage_taker_prisoners_hostage_taker'
        fill_in 'hostage_taker_date_most_recent_prisoners_hostage_taker_incident', with: @risk.date_most_recent_prisoners_hostage_taker_incident
      end
    end

    def fill_in_public_hostage_taker
      if @risk.public_hostage_taker
        check 'hostage_taker_public_hostage_taker'
        fill_in 'hostage_taker_date_most_recent_public_hostage_taker_incident', with: @risk.date_most_recent_public_hostage_taker_incident
      end
    end

    def fill_in_harassments
      fill_in_harassment
      fill_in_intimidation
      save_and_continue
    end

    def fill_in_harassment
      if @risk.harassment == 'yes'
        choose 'harassments_harassment_yes'
        fill_in 'harassments_harassment_details', with: @risk.harassment_details
      else
        choose 'harassments_harassment_no'
      end
    end

    def fill_in_intimidation
      if @risk.intimidation == 'yes'
        choose 'harassments_intimidation_yes'
        fill_in_checkbox_with_details('Staff', @risk, :intimidation_to_staff)
        fill_in_checkbox_with_details('Public', @risk, :intimidation_to_public)
        fill_in_checkbox_with_details('Prisoners', @risk, :intimidation_to_other_detainees)
        fill_in_checkbox_with_details('Witnesses', @risk, :intimidation_to_witnesses)
      else
        choose 'harassments_intimidation_no'
      end
    end

    def fill_in_sex_offences
      if @risk.sex_offence == 'yes'
        choose 'sex_offences_sex_offence_yes'
        fill_in_checkbox('Adult male', @risk, :sex_offence_adult_male_victim)
        fill_in_checkbox('Adult female', @risk, :sex_offence_adult_female_victim)
        fill_in_checkbox_with_details('Under 18', @risk, :sex_offence_under18_victim)
      else
        choose 'sex_offences_sex_offence_no'
      end
      save_and_continue
    end

    def fill_in_security
      fill_in_current_e_risk
      fill_in_previous_escape_attempts
      fill_in_category_a
      fill_in_escort_risk_assessment
      fill_in_escape_pack
      save_and_continue
    end

    def fill_in_current_e_risk
      if @risk.current_e_risk == 'yes'
        choose 'security_current_e_risk_yes'
        choose "security_current_e_risk_details_#{@risk.current_e_risk_details}"
      else
        choose 'security_current_e_risk_no'
      end
    end

    def fill_in_previous_escape_attempts
      if @risk.previous_escape_attempts == 'yes'
        choose 'security_previous_escape_attempts_yes'
        fill_in_checkbox_with_details('Prison', @risk, :prison_escape_attempt)
        fill_in_checkbox_with_details('Court', @risk, :court_escape_attempt)
        fill_in_checkbox_with_details('Police', @risk, :police_escape_attempt)
        fill_in_checkbox_with_details('Other', @risk, :other_type_escape_attempt)
      else
        choose 'security_previous_escape_attempts_no'
      end
    end

    def fill_in_category_a
      if @risk.category_a == 'yes'
        choose 'security_category_a_yes'
      else
        choose 'security_category_a_no'
      end
    end

    def fill_in_escort_risk_assessment
      if @risk.escort_risk_assessment == 'yes'
        choose 'security_escort_risk_assessment_yes'
        fill_in 'security_escort_risk_assessment_completion_date', with: @risk.escort_risk_assessment_completion_date
      else
        choose 'security_escort_risk_assessment_no'
      end
    end

    def fill_in_escape_pack
      if @risk.escape_pack == 'yes'
        choose 'security_escape_pack_yes'
        fill_in 'security_escape_pack_completion_date', with: @risk.escape_pack_completion_date
      else
        choose 'security_escape_pack_no'
      end
    end

    def fill_in_substance_misuse
      if @risk.substance_supply == 'yes'
        choose 'substance_misuse_substance_supply_yes'
        fill_in 'substance_misuse_substance_supply_details', with: @risk.substance_supply_details
      else
        choose 'substance_misuse_substance_supply_no'
      end
      save_and_continue
    end

    def fill_in_concealed_weapons
      fill_in_optional_details('Conceals weapons', @risk, :conceals_weapons)
      fill_in_optional_details('Conceals drugs', @risk, :conceals_drugs)
      fill_in_concealed_mobile_phone_or_other_items
      save_and_continue
    end

    def fill_in_concealed_mobile_phone_or_other_items
      if @risk.conceals_mobile_phone_or_other_items == 'yes'
        choose 'concealed_weapons_conceals_mobile_phone_or_other_items_yes'
        fill_in_concealed_mobile_phones
        fill_in_concealed_sim_cards
        fill_in_concealed_other_items
      else
        choose 'concealed_weapons_conceals_mobile_phone_or_other_items_no'
      end
    end

    def fill_in_concealed_mobile_phones
      if @risk.conceals_mobile_phones
        check 'concealed_weapons_conceals_mobile_phones'
      end
    end

    def fill_in_concealed_sim_cards
      if @risk.conceals_other_items
        check 'concealed_weapons_conceals_sim_cards'
      end
    end

    def fill_in_concealed_other_items
      if @risk.conceals_other_items
        check 'concealed_weapons_conceals_other_items'
        fill_in 'concealed_weapons_conceals_other_items_details', with: @risk.conceals_other_items_details
      end
    end

    def fill_in_arson
      if @risk.arson == 'yes'
        choose 'arson_arson_yes'
      else
        choose 'arson_arson_no'
      end

      if @risk.damage_to_property == 'yes'
        choose 'arson_damage_to_property_yes'
      else
        choose 'arson_damage_to_property_no'
      end
      save_and_continue
    end
  end
end
