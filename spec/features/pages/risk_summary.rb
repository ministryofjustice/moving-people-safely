module Page
  class RiskSummary < Base
    include Page::AssessmentSummaryPageHelpers

    def confirm_risk_details(risk)
      check_risk_to_self(risk)
      check_segregation(risk)
      check_security(risk)
      check_violent_or_dangerous(risk) if risk.location == 'prison'
      check_harassment_and_gangs_section(risk) if risk.location == 'prison'
      check_discrimination(risk)
      check_escape(risk) if risk.location == 'prison'
      check_hostage_taker(risk)
      check_sex_offences(risk) if risk.location == 'prison'
      check_concealed_weapons(risk)
      check_arson(risk) if risk.location == 'prison'
      check_return_instructions(risk)
      check_other_risk(risk)
    end

    private

    def check_risk_to_self(risk)
      if risk.location == 'prison'
        check_section(risk, 'risk_to_self', %w[acct_status self_harm])
      elsif risk.location == 'police'
        check_section(risk, 'risk_to_self', %w[self_harm])
      end
    end

    def check_segregation(risk)
      if risk.location == 'prison'
        check_section(risk, 'segregation', %w[csra rule_45 vulnerable_prisoner])
      elsif risk.location == 'police'
        check_section(risk, 'segregation', %w[csra vulnerable_prisoner])
      end
    end

    def check_security(risk)
      if risk.location == 'prison'
        check_section(risk, 'security', %w[controlled_unlock high_profile pnc_warnings])
      elsif risk.location == 'police'
        check_section(risk, 'security', %w[high_profile violent_or_dangerous gang_member previous_escape_attempts])
      end
    end

    def check_violent_or_dangerous(risk)
      check_section(risk, 'violent_or_dangerous', %w[violent_or_dangerous])
    end

    def check_harassment_and_gangs_section(risk)
      check_section(risk, 'harassment_and_gangs', %w[intimidation_public intimidation_prisoners gang_member])
    end

    def check_discrimination(risk)
      check_section(risk, 'discrimination', %w[violence_to_staff risk_to_females homophobic racist discrimination_to_other_religions other_violence_due_to_discrimination])
    end

    def check_escape(risk)
      check_section(risk, 'escape', %w[current_e_risk previous_escape_attempts escort_risk_assessment escape_pack])
    end

    def check_hostage_taker(risk)
      if risk.location == 'prison'
        check_section(risk, 'hostage_taker', %w[hostage_taker])
      elsif risk.location == 'police'
        check_section(risk, 'hostage_taker', %w[hostage_taker sex_offence arson])
      end
    end

    def check_sex_offences(risk)
      check_section(risk, 'sex_offences', %w[sex_offence])
    end

    def check_concealed_weapons(risk)
      if risk.location == 'prison'
        check_section(risk, 'concealed_weapons', %w[uses_weapons conceals_weapons conceals_drugs conceals_mobile_phone_or_other_items substance_supply])
      elsif risk.location == 'police'
        check_section(risk, 'concealed_weapons', %w[uses_weapons conceals_weapons conceals_drugs conceals_mobile_phone_or_other_items])
      end
    end

    def check_arson(risk)
      check_section(risk, 'arson', %w[ arson ])
    end

    def check_return_instructions(risk)
      if risk.violence_to_staff == 'yes'
        check_question(risk, 'return_instructions', 'must_return_to')
        check_question(risk, 'return_instructions', 'must_return_to_details')
      end
    end

    def check_other_risk(risk)
      if risk.location == 'prison'
        check_section(risk, 'other_risk', %w[other_risk])
      elsif risk.location == 'police'
        check_section(risk, 'other_risk', %w[pnc_warnings other_risk])
      end
    end
  end
end
