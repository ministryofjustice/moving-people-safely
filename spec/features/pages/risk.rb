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
      fill_in_optional_details('Open ACCT?', @risk, :open_acct)
      fill_in_optional_details('Risk of suicide or self-harm?', @risk, :suicide)
      save_and_continue
    end

    def fill_in_risk_from_others
      fill_in_optional_details('Rule 45?', @risk, :rule_45)
      fill_in_optional_details('CSRA?', @risk, :csra)
      fill_in_optional_details('Is the detainee at risk of verbal abuse from others?', @risk, :verbal_abuse)
      fill_in_optional_details('Is the detainee at risk of physical abuse from others?', @risk, :physical_abuse)
      save_and_continue
    end

    def fill_in_violence
      if @risk.violent == 'yes'
        choose 'violence_violent_yes'
        fill_in_checkbox_with_details('Prison staff', @risk, :prison_staff)
        fill_in_checkbox_with_details('Risk to females', @risk, :risk_to_females)
        fill_in_checkbox_with_details('Escort or court staff', @risk, :escort_or_court_staff)
        fill_in_checkbox_with_details('Healthcare staff', @risk, :healthcare_staff)
        fill_in_checkbox_with_details('Other detainees', @risk, :other_detainees)
        fill_in_checkbox_with_details('Homophobic', @risk, :homophobic)
        fill_in_checkbox_with_details('Racist', @risk, :racist)
        fill_in_checkbox_with_details('Public offence related', @risk, :public_offence_related)
        fill_in_checkbox_with_details('Police', @risk, :police)
      else
        choose 'violence_violent_no'
      end
      save_and_continue
    end

    def fill_in_harassments
      if @risk.stalker_harasser_bully == 'yes'
        choose 'harassments_stalker_harasser_bully_yes'
        fill_in_checkbox_with_details('Hostage taker', @risk, :hostage_taker)
        fill_in_checkbox_with_details('Stalker', @risk, :stalker)
        fill_in_checkbox_with_details('Harasser', @risk, :harasser)
        fill_in_checkbox_with_details('Intimidator', @risk, :intimidator)
        fill_in_checkbox_with_details('Bully', @risk, :bully)
      else
        choose 'harassments_stalker_harasser_bully_no'
      end
      save_and_continue
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
