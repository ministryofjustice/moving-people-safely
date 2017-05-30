module Page
  class RiskSummary < Base
    include Page::AssessmentSummaryPageHelpers

    def confirm_risk_details(risk)
      check_section(risk, 'risk_to_self', %w[acct_status])
      check_section(risk, 'risk_from_others', %w[rule_45 high_profile])
      check_discrimination_section(risk)
      check_violence_section(risk)
      check_hostage_taker_section(risk)
      check_harassment_section(risk)
      check_sex_offences_section(risk)
      check_security_section(risk)
      check_section(risk, 'substance_misuse', %w[substance_supply])
      check_concealed_weapons_section(risk)
      check_section(risk, 'arson', %w[ arson ])
    end

    private

    def check_violence_section(risk)
      check_section(risk, 'csra', %w[csra])
      check_section(risk, 'violence_to_staff', %w[violence_to_staff])
      check_violence_to_other_detainees(risk)
      check_violence_to_general_public(risk)
      check_controlled_unlock_required(risk)
    end

    def check_discrimination_section(risk)
      check_section(risk, 'discrimination', %w[risk_to_females homophobic racist discrimination_to_other_religions other_violence_due_to_discrimination])
    end

    def check_violence_to_other_detainees(risk)
      if risk.violence_to_other_detainees == 'yes'
        check_section(risk, 'violence_to_other_detainees', %w[co_defendant gang_member other_violence_to_other_detainees])
      else
        check_section_is_all_no(risk, 'violence_to_other_detainees', %w[co_defendant gang_member other_violence_to_other_detainees])
      end
    end

    def check_violence_to_general_public(risk)
      if risk.violence_to_general_public == 'yes'
        check_question(risk, 'violence_to_general_public', 'violence_to_general_public')
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

    def check_harassment_section(risk)
      check_intimidation(risk)
    end

    def check_intimidation(risk)
      fields = %w[intimidation_to_staff intimidation_to_public intimidation_to_other_detainees intimidation_to_witnesses]
      if risk.intimidation == 'yes'
        check_section(risk, 'intimidation', fields)
      else
        check_section_is_all_no(risk, 'intimidation', fields)
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

    def check_security_section(risk)
      check_current_e_risk(risk)
      check_previous_escape_attempts(risk)
      check_question(risk, 'category_a', 'category_a')
      check_question(risk, 'escort_details', 'escort_risk_assessment')
      check_question(risk, 'escort_details', 'escape_pack')
    end

    def check_current_e_risk(risk)
      if risk.current_e_risk == 'yes'
        check_question(risk, 'escape_status', 'current_e_risk_details')
      end
    end

    def check_previous_escape_attempts(risk)
      fields = %w[prison_escape_attempt court_escape_attempt
                  police_escape_attempt other_type_escape_attempt]
      if risk.previous_escape_attempts == 'yes'
        check_section(risk, 'previous_escape_attempts', fields)
      else
        check_section_is_all_no(risk, 'previous_escape_attempts', fields)
      end
    end

    def check_concealed_weapons_section(risk)
      check_section(risk, 'concealed_weapons', %w[conceals_weapons])
      check_section(risk, 'concealed_weapons', %w[conceals_drugs])
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
  end
end
