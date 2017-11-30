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
      fields = %w[intimidation_to_public intimidation_to_other_detainees intimidation_to_witnesses]
      if risk.intimidation == 'yes'
        check_section(risk, 'harassment_and_gangs', fields)
      else
        check_section_is_all_no(risk, 'harassment_and_gangs', fields)
      end
    end

    def check_controlled_unlock_required(risk)
      if risk.controlled_unlock_required == 'yes'
        check_section(risk, 'controlled_unlock', %w[two_officer_unlock three_officer_unlock four_officer_unlock more_than_four])
      end
    end

    def check_hostage_taker_section(risk)
      fields = %w[staff_hostage_taker prisoners_hostage_taker public_hostage_taker]
      if risk.hostage_taker == 'yes'
        check_section(risk, 'hostage_taker', fields)
      else
        check_section_is_all_no(risk, 'hostage_taker', fields)
      end
    end

    def check_sex_offences_section(risk)
      fields = %w[sex_offence_adult_male_victim sex_offence_adult_female_victim
                  sex_offence_under18_victim]
      if risk.sex_offence == 'yes'
        check_section(risk, 'sex_offences', fields)
      else
        check_section_is_all_no(risk, 'sex_offences', fields)
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
      fields = %w[conceals_mobile_phones conceals_sim_cards
                  conceals_other_items]
      if risk.conceals_mobile_phone_or_other_items == 'yes'
        check_section(risk, 'concealed_weapons', fields)
      else
        check_section_is_all_no(risk, 'concealed_weapons', fields)
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
