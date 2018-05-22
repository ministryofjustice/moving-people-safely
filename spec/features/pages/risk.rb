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
      fill_in_segregation
      fill_in_security
      fill_in_violence
      fill_in_harassment_and_gangs
      fill_in_discrimination
      fill_in_escape
      fill_in_hostage_taker
      fill_in_sex_offences
      fill_in_concealed_weapons
      fill_in_arson
      fill_in_return_instructions
      fill_in_other_risk
    end

    def fill_in_risk_to_self
      fill_in_optional_details("What is the prisoner's ACCT status?", @risk, :acct_status)
      fill_in_optional_details("Is there any other risk of self harm on this journey?", @risk, :self_harm)
      save_and_continue
    end

    def fill_in_segregation
      fill_in_optional_details('What is their Cell Sharing Risk Assessment (CSRA) risk level?', @risk, :csra)
      fill_in_optional_details('Are they held under Rule 45?', @risk, :rule_45)
      fill_in_optional_details('Are they a vulnerable prisoner?', @risk, :vulnerable_prisoner)
      save_and_continue
    end

    def fill_in_security
      fill_in_controlled_unlock
      fill_in_category_a
      fill_in_optional_details('Are they of high public interest?', @risk, :high_profile)
      fill_in_optional_details('PNC warnings', @risk, :pnc_warnings)
      save_and_continue
    end

    def fill_in_violence
      if @risk.violent_or_dangerous == 'yes'
        choose 'violent_or_dangerous_violent_or_dangerous_yes'
        fill_in 'violent_or_dangerous_violent_or_dangerous_details', with: @risk.violent_or_dangerous_details
      else
        choose 'violent_or_dangerous_violent_or_dangerous_no'
      end
      save_and_continue
    end

    def fill_in_harassment_and_gangs
      fill_in_intimidation
      fill_in_optional_details('Are they a gang member or involved in organised crime?', @risk, :gang_member)
      save_and_continue
    end

    def fill_in_discrimination
      fill_in_optional_details('Are they a risk to staff?', @risk, :violence_to_staff)
      fill_in_optional_details('Are they a risk to females?', @risk, :risk_to_females)
      fill_in_optional_details('Are they a risk to lesbian, gay, bisexual, transgender or transexual (LGBT) people?', @risk, :homophobic)
      fill_in_optional_details('Are they a risk to other races?', @risk, :racist)
      fill_in_optional_details('Are they a risk to other religions?', @risk, :discrimination_to_other_religions)
      fill_in_optional_details('Are they a risk to any other groups?', @risk, :other_violence_due_to_discrimination)
      save_and_continue
    end

    def fill_in_escape
      fill_in_current_e_risk
      fill_in_previous_escape_attempts
      fill_in_escort_risk_assessment
      fill_in_escape_pack
      save_and_continue
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

    def fill_in_sex_offences
      if @risk.sex_offence == 'yes'
        choose 'sex_offences_sex_offence_yes'
        fill_in_checkbox('Adult male', @risk, :sex_offence_adult_male_victim)
        fill_in_checkbox('Adult female', @risk, :sex_offence_adult_female_victim)
        fill_in_checkbox_with_details('Under 18', @risk, :sex_offence_under18_victim)
        fill_in 'sex_offence_date_most_recent_sexual_offence', with: @risk.date_most_recent_sexual_offence
      else
        choose 'sex_offences_sex_offence_no'
      end
      save_and_continue
    end

    def fill_in_concealed_weapons
      fill_in_optional_details('Have they created or used weapons in custody?', @risk, :uses_weapons)
      fill_in_optional_details('Have they concealed weapons in custody?', @risk, :conceals_weapons)
      fill_in_optional_details('Have they concealed drugs in custody?', @risk, :conceals_drugs)
      fill_in_concealed_mobile_phone_or_other_items
      fill_in_optional_details('Is there a risk that they might traffic drugs on this journey?', @risk, :substance_supply)
      save_and_continue
    end

    def fill_in_arson
      if @risk.arson == 'yes'
        choose 'arson_arson_yes'
      else
        choose 'arson_arson_no'
      end
      save_and_continue
    end

    def fill_in_return_instructions
      fill_in_must_return
      fill_in_must_not_return
      save_and_continue
    end

    def fill_in_other_risk
      fill_in_optional_details('Is there any other information related to risk on this journey you would like to include?', @risk, :other_risk)
      save_and_continue
    end

    private

    def fill_in_controlled_unlock
      if @risk.controlled_unlock == 'yes'
        choose 'security_controlled_unlock_yes'
        choose 'security_controlled_unlock_more_than_four'
        fill_in 'security_controlled_unlock_details', with: @risk.controlled_unlock_details
      else
        choose 'security_controlled_unlock_no'
      end
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

    def fill_in_intimidation
      if @risk.intimidation_public == 'yes'
        choose 'harassment_and_gangs_intimidation_public_yes'
        fill_in 'harassment_and_gangs_intimidation_public_details', with: @risk.intimidation_public_details
      else
        choose 'harassment_and_gangs_intimidation_public_no'
      end
      if @risk.intimidation_public == 'yes'
        choose 'harassment_and_gangs_intimidation_prisoners_yes'
        fill_in 'harassment_and_gangs_intimidation_prisoners_details', with: @risk.intimidation_prisoners_details
      else
        choose 'harassment_and_gangs_intimidation_prisoners_no'
      end
    end

    def fill_in_previous_escape_attempts
      if @risk.previous_escape_attempts == 'yes'
        choose 'escape_previous_escape_attempts_yes'
        fill_in 'escape_previous_escape_attempts_details', with: @risk.previous_escape_attempts_details
      else
        choose 'escape_previous_escape_attempts_no'
      end
    end

    def fill_in_category_a
      if @risk.category_a == 'yes'
        choose 'security_category_a_yes'
      else
        choose 'security_category_a_no'
      end
    end

    def fill_in_current_e_risk
      if @risk.current_e_risk == 'yes'
        choose 'escape_current_e_risk_yes'
        choose "escape_current_e_risk_details_#{@risk.current_e_risk_details}"
      else
        choose 'escape_current_e_risk_no'
      end
    end

    def fill_in_escort_risk_assessment
      if @risk.escort_risk_assessment == 'yes'
        choose 'escape_escort_risk_assessment_yes'
      else
        choose 'escape_escort_risk_assessment_no'
      end
    end

    def fill_in_escape_pack
      if @risk.escape_pack == 'yes'
        choose 'escape_escape_pack_yes'
      else
        choose 'escape_escape_pack_no'
      end
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

    def fill_in_must_return
      if @risk.must_return == 'yes'
        choose 'return_instructions_must_return_yes'
        fill_in 'return_instructions_must_return_to', with: @risk.must_return_to
        fill_in 'return_instructions_must_return_to', with: @risk.must_return_to_details
      else
        choose 'return_instructions_must_return_no'
      end
    end

    def fill_in_must_not_return
      if @risk.has_must_not_return_details == 'yes'
        choose 'return_instructions_has_must_not_return_details_yes'
        @risk.must_not_return_details.each_with_index do |detail, i|
          add_must_not_return_detail unless i == 0
          fill_in_must_not_return_detail(detail, i)
        end
      else
        choose 'return_instructions_has_must_not_return_details_no'
      end
    end

    def add_must_not_return_detail
      click_button 'Add another establishment'
    end

    def fill_in_must_not_return_detail(detail, i)
      el = all('.multiple-wrapper').to_a[i]
      within(el) do
        fill_in 'Establishment', with: detail.establishment
        fill_in 'Give details of why they must not be sent here:', with: detail.establishment_details
      end
    end
  end
end
