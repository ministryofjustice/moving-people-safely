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
      fill_in_non_association_markers
      fill_in_security
      fill_in_substance_misuse
      fill_in_concealed_weapons
      fill_in_arson
      fill_in_communication
    end

    def fill_in_risk_to_self
      fill_in_optional_details('What is the most recent ACCT status of the detainee?', @risk, :acct_status)
      save_and_continue
    end

    def fill_in_risk_from_others
      fill_in_optional_details('Rule 45 (Detainee separated for their own protection)?', @risk, :rule_45)
      fill_in_optional_details('CSRA (Cell Share Risk Assessment)?', @risk, :csra)
      fill_in_optional_details('Is the detainee a victim or possible victim of abuse within prison?', @risk, :victim_of_abuse)
      fill_in_optional_details('Is the detainee of high public interest?', @risk, :high_profile)
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
        choose @risk.sex_offence_victim.humanize
        if @risk.sex_offence_details
          fill_in 'sex_offences_sex_offence_details', with: @risk.sex_offence_details
        end
      else
        choose 'sex_offences_sex_offence_no'
      end
      save_and_continue
    end

    def fill_in_security
      if @risk.current_e_risk == 'yes'
        choose 'security_current_e_risk_yes'
        choose "security_current_e_risk_details_#{@risk.current_e_risk_details}"
      else
        choose 'security_current_e_risk_no'
      end
      fill_in_optional_details('Category A?', @risk, :category_a)
      fill_in_optional_details('Restricted status?', @risk, :restricted_status)
      check 'Escape pack' if @risk.escape_pack
      check 'Escape risk assessment' if @risk.escape_risk_assessment
      check 'Cuffing protocol'  if @risk.cuffing_protocol
      save_and_continue
    end

    def fill_in_non_association_markers
      fill_in_optional_details('Non-association markers?', @risk, :non_association_markers)
      save_and_continue
    end

    def fill_in_substance_misuse
      fill_in_optional_details('Is there a risk of them SUPPLYING drugs or alcohol?', @risk, :substance_supply)
      fill_in_optional_details('Is there a risk of them USING drugs or alcohol?', @risk, :substance_use)
      save_and_continue
    end

    def fill_in_concealed_weapons
      fill_in_optional_details('Concealed weapons, mobile phones or other items', @risk, :conceals_weapons)
      save_and_continue
    end

    def fill_in_arson
      if @risk.arson == 'yes'
        choose 'arson_arson_yes'
        choose "arson_arson_value_#{@risk.arson_value}"
        fill_in 'arson_arson_details', with: @risk.arson_details
      else
        choose 'arson_arson_no'
      end
      fill_in_optional_details('Damage to property?', @risk, :damage_to_property)
      save_and_continue
    end

    def fill_in_communication
      if @risk.interpreter_required == 'yes'
        choose 'communication_interpreter_required_yes'
        fill_in 'communication[language]', with: @risk.language
      else
        choose 'communication_interpreter_required_no'
      end
      fill_in_optional_details('Does the detainee have hearing / speech / sight impairments?', @risk, :hearing_speach_sight)
      fill_in_optional_details('Does the detainee have reading / writing issues?', @risk, :can_read_and_write)
      save_and_continue
    end
  end
end
