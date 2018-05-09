module Page
  class RiskSummary < Base
    include Page::AssessmentSummaryPageHelpers

    def confirm_risk_details(risk)
      check_section(risk, 'risk_to_self', %w[acct_status self_harm])
      check_segregation(risk)
      check_security(risk)
      check_harassment_and_gangs_section(risk)
      check_section(risk, 'discrimination', %w[violence_to_staff risk_to_females homophobic racist discrimination_to_other_religions other_violence_due_to_discrimination])
      check_escape_section(risk)
      check_hostage_taker_section(risk)
      check_sex_offences_section(risk)
      check_concealed_weapons_section(risk)
      check_return_instructions_section(risk)
      check_section(risk, 'arson', %w[ arson ])
    end

    private

    def check_segregation(risk)
      check_section(risk, 'segregation', %w[csra rule_45 vulnerable_prisoner])
    end

    def check_security(risk)
      check_section(risk, 'security', %w[category_a high_profile pnc_warnings])
      check_controlled_unlock_required(risk)
    end

    def check_harassment_and_gangs_section(risk)
      check_intimidation(risk)
      check_section(risk, 'harassment_and_gangs', %w[gang_member])
    end

    def check_intimidation(risk)
      fields = %w[intimidation_public intimidation_prisoners]
      if risk.intimidation_public == 'yes' || risk.intimidation_prisoners == 'yes'
        check_section(risk, 'harassment_and_gangs', fields)
      else
        check_section_is_all_no(risk, 'harassment_and_gangs', fields)
      end
    end

    def check_controlled_unlock_required(risk)
      if risk.controlled_unlock_required == 'yes'
        check_section(risk, 'security', %w[controlled_unlock])
      end
    end

    def check_hostage_taker_section(risk)
      if risk.hostage_taker == 'yes'
        check_section(risk, 'hostage_taker', %w[hostage_taker])
      end
    end

    def check_sex_offences_section(risk)
      if risk.sex_offence == 'yes'
        check_section(risk, 'sex_offences', %w[sex_offences])
      end
    end

    def check_escape_section(risk)
      check_current_e_risk(risk)
      check_section(risk, 'escape', %w[previous_escape_attempts escort_risk_assessment escape_pack])
    end

    def check_current_e_risk(risk)
      if risk.current_e_risk == 'yes'
        check_question(risk, 'escape_status', 'current_e_risk_details')
      end
    end

    def check_concealed_weapons_section(risk)
      check_section(risk, 'concealed_weapons', %w[conceals_weapons conceals_drugs substance_supply])
      check_conceals_mobile_phone_or_other_items(risk)
    end

    def check_conceals_mobile_phone_or_other_items(risk)
      if risk.conceals_mobile_phone_or_other_items == 'yes'
        check_section(risk, 'concealed_weapons', %w[conceals_mobile_phone_or_other_items])
      end
    end

    def check_return_instructions_section(risk)
      if risk.violence_to_staff == 'yes'
        check_question(risk, 'return_instructions', 'must_return_to')
        check_question(risk, 'return_instructions', 'must_return_to_details')
      end
    end
  end
end
