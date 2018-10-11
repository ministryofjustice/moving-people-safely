module Page
  class Risk < Base
    def expect_summary_page_with_completed_status
      within('.status-label--complete') do
        expect(page).to have_content('Complete')
      end
    end

    def complete_forms(risk)
      @risk = risk
      continue_from_intro if @risk.location == 'police'
      fill_in_risk_to_self
      fill_in_segregation
      fill_in_security
      fill_in_violence if @risk.location == 'prison'
      fill_in_harassment_and_gangs if @risk.location == 'prison'
      fill_in_discrimination
      fill_in_escape if @risk.location == 'prison'
      fill_in_hostage_taker
      fill_in_sex_offences if @risk.location == 'prison'
      fill_in_concealed_weapons
      fill_in_arson if @risk.location == 'prison'
      fill_in_return_instructions if @risk.location == 'prison'
      fill_in_other_risk
    end

    def continue_from_intro
      click_link 'Continue'
    end

    def fill_in_risk_to_self
      fill_in_optional_details("What is the prisoner's ACCT status?", @risk, :acct_status) if @risk.location == 'prison'
      fill_in_optional_details("Is there a risk that they might self harm or attempt suicide?", @risk, :self_harm)
      save_and_continue
    end

    def fill_in_segregation
      if @risk.location == 'prison'
        fill_in_optional_details('What is their Cell Sharing Risk Assessment (CSRA) risk level?', @risk, :csra)
        fill_in_optional_details('Are they held under Rule 45?', @risk, :rule_45)
        fill_in_optional_details('Are they a vulnerable prisoner?', @risk, :vulnerable_prisoner)
      elsif @risk.location == 'police'
        fill_in_optional_details('Is there any reason they should not share a cell with another person?', @risk, :csra)
        fill_in_optional_details('Are they at risk from other people?', @risk, :vulnerable_prisoner)
      end
      save_and_continue
    end

    def fill_in_security
      if @risk.location == 'prison'
        fill_in_optional_details('Are they on a controlled unlock?', @risk, :controlled_unlock)
        fill_in_optional_details('Are they of high public interest?', @risk, :high_profile)
        fill_in_optional_details('PNC warnings', @risk, :pnc_warnings)
      elsif @risk.location == 'police'
        fill_in_optional_details('Are they of high public interest?', @risk, :high_profile)
        fill_in_optional_details('Are they violent or dangerous?', @risk, :violent_or_dangerous)
        fill_in_optional_details('Are they a gang member or involved in organised crime?', @risk, :gang_member)
        fill_in_optional_details('Are they an escape risk?', @risk, :previous_escape_attempts)
      end
      save_and_continue
    end

    def fill_in_violence
      fill_in_optional_details('Are they violent or dangerous?', @risk, :violent_or_dangerous)
      save_and_continue
    end

    def fill_in_harassment_and_gangs
      if @risk.location == 'prison'
        fill_in_optional_details('Are they a known public harasser or witness intimidator?', @risk, :intimidation_public)
        fill_in_optional_details('Do they bully or intimidate other prisoners?', @risk, :intimidation_prisoners)
        fill_in_optional_details('Are they a gang member or involved in organised crime?', @risk, :gang_member)
      elsif @risk.location == 'police'
        fill_in_optional_details('Are they a known harasser or intimidator?', @risk, :intimidation_public)
        fill_in_optional_details('Are they a gang member or involved in organised crime?', @risk, :gang_member)
      end
      save_and_continue
    end

    def fill_in_discrimination
      fill_in_optional_details('Are they a risk to staff?', @risk, :violence_to_staff)
      fill_in_optional_details('Are they a risk to females?', @risk, :risk_to_females)
      fill_in_optional_details('Are they a risk to lesbian, gay, bisexual, transgender, transexual or queer (LGBTQ) people?', @risk, :homophobic)
      fill_in_optional_details('Are they a risk to other races?', @risk, :racist)
      fill_in_optional_details('Are they a risk to other religions?', @risk, :discrimination_to_other_religions)
      if @risk.location == 'prison'
        fill_in_optional_details('Are they a risk to any other groups?', @risk, :other_violence_due_to_discrimination)
      elsif @risk.location == 'police'
        fill_in_optional_details('Are they a risk to any other group that has not already been mentioned?', @risk, :other_violence_due_to_discrimination)
      end
      save_and_continue
    end

    def fill_in_escape
      fill_in_optional_details('Are they on the Escape List (E-List)?', @risk, :current_e_risk)
      fill_in_optional_details('Are they an escape risk?', @risk, :previous_escape_attempts)
      fill_in_optional_details('Is an Escort Risk Assessment needed for this journey?', @risk, :escort_risk_assessment)
      fill_in_optional_details('Is an Escape Pack needed for this journey?', @risk, :escape_pack)
      save_and_continue
    end

    def fill_in_hostage_taker
      if @risk.location == 'prison'
        fill_in_optional_details('Are they a hostage taker?', @risk, :hostage_taker)
      elsif @risk.location == 'police'
        fill_in_optional_details('Are they a hostage taker?', @risk, :hostage_taker)
        fill_in_optional_details('Are they a current or previous sex offender?', @risk, :sex_offence)
        fill_in_optional_details('Are they an arsonist?', @risk, :arson)
      end
      save_and_continue
    end

    def fill_in_sex_offences
      fill_in_optional_details('Are they a current or previous sex offender?', @risk, :sex_offence)
      save_and_continue
    end

    def fill_in_concealed_weapons
      fill_in_optional_details('Have they created or used weapons in custody?', @risk, :uses_weapons)
      fill_in_optional_details('Have they concealed weapons in custody?', @risk, :conceals_weapons)
      fill_in_optional_details('Have they concealed drugs in custody?', @risk, :conceals_drugs)
      fill_in_optional_details('Have they concealed mobile phones, SIMs or other items in custody?', @risk, :conceals_mobile_phone_or_other_items)
      fill_in_optional_details('Is there a risk that they might traffic drugs on this journey?', @risk, :substance_supply) if @risk.location == 'prison'
      save_and_continue
    end

    def fill_in_arson
      fill_in_optional_details('Are they an arsonist?', @risk, :arson)
      save_and_continue
    end

    def fill_in_return_instructions
      fill_in_must_return
      fill_in_must_not_return
      save_and_continue
    end

    def fill_in_other_risk
      fill_in_optional_details('Do they have PNC warnings that haven’t been covered by the questions asked?', @risk, :pnc_warnings) if @risk.location == 'police'
      fill_in_optional_details('Is there any other information related to risk on this journey you would like to include?', @risk, :other_risk)
      save_and_continue
    end

    private

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
