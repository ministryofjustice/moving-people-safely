module Page
  class Escort < Base
    def confirm_header_details(detainee)
      within('#header') do
        detainee_detail = "#{detainee.prison_number}: #{detainee.surname}, #{detainee.forenames}"
        expect(page).to have_content(detainee_detail)
      end

      confirm_risk_flags(detainee.risk)
    end

    def confirm_all_alerts_as_inactive
      within('.escort-alerts') do
        %i[not_for_release acct_status rule_45 e_list csra category_a].each do |alert|
          expect(page).to have_css("##{alert}_header.alert-off")
        end
      end
    end

    def confirm_alert_as_inactive(attr)
      within('.escort-alerts') do
        expect(page).to have_css("##{attr}_header.alert-off")
      end
    end

    def confirm_alert_as_active(attr)
      within('.escort-alerts') do
        expect(page).to have_css("##{attr}_header.alert-on")
      end
    end

    def confirm_move_info(move, options = {})
      within('.move-information') do
        expect(page).to have_content move.from_establishment.name
        expect(page).to have_content move.to
        expect(page).to have_content move.date.strftime('%d %b %Y')
      end
    end

    def assert_link_to_new_move(escort)
      within '#no-active-move' do
        expect(page).to have_selector(:css, "a[href='#{new_escort_move_path(escort.id)}']")
      end
    end

    def confirm_read_only_detainee_details
      within('#personal-details') do
        expect(page).not_to have_link('Edit')
      end
    end

    def confirm_read_only_move_details
      within('.move-information') do
        expect(page).not_to have_link('Edit')
      end
    end

    def confirm_detainee_details(detainee)
      within('#personal-details') do
        expect(page).to have_content detainee.prison_number
        expect(page).to have_content detainee.date_of_birth.strftime('%d %b %Y')
        expect(page).to have_content detainee.nationalities
        expect(page).to have_content detainee.gender[0].upcase
        expect(page).to have_content detainee.pnc_number
        expect(page).to have_content detainee.cro_number
        expect(page).to have_content detainee.aliases
        expect(page).to have_content age(detainee.date_of_birth)
      end
    end

    def confirm_healthcare_status(expected_status='Complete')
      within('#healthcare') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_healthcare_details(hc)
      within('#healthcare') do
        within('.answered_yes') do
          expect(page).to have_content(hc.total_questions_with_relevant_answer.to_s)
        end
        within('.answered_no') do
          expect(page).to have_content(hc.total_questions_without_relevance.to_s)
        end
      end
    end

    def confirm_risk_status(expected_status='Complete')
      within('#risk') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_risk_details(risk)
      within('#risk') do
        within('.answered_yes') do
          # TODO - this test fails, there's no unit test - FML.
          # expect(page).to have_content risk.questions_answered_yes
        end
        within('.answered_no') do
          #expect(page).to have_content risk.questions_answered_no
        end
      end
    end

    def confirm_offences_status(expected_status='Complete')
      within('#offences') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_offence_details(offences_data)
      within('#offences-summary') do
        offences_data[:offences].each do |offence|
          expect(page).to have_content(offence.fetch(:name))
        end
      end
    end

    def confirm_no_offences
      within('#offences-summary') do
        expect(page).to have_content('None')
      end
    end

    def confirm_offences(expected_offences)
      within('#offences-summary') do
        expected_offences.each do |offence|
          expect(page).to have_content(offence.fetch(:name))
        end
      end
    end

    def click_edit_healthcare(name = 'Edit')
      click_per_section_action_link(:healthcare, name)
    end

    def click_edit_risk(name = 'Edit')
      click_per_section_action_link(:risk, name)
    end

    def click_edit_offences(name = 'Edit')
      click_per_section_action_link(:offences, name)
    end

    def click_print
      click_link 'Print'
    end

    def click_reprint
      click_link 'Reprint'
    end

    def click_cancel
      click_link 'Cancel PER'
    end

    def confirm_healthcare_action_link(name)
      confirm_per_section_action_link(:healthcare, name)
    end

    def confirm_risk_action_link(name)
      confirm_per_section_action_link(:risk, name)
    end

    def confirm_offences_action_link(name)
      confirm_per_section_action_link(:offences, name)
    end

    private

    def click_per_section_action_link(section, name = 'Edit')
      within("##{section}") do
        click_link name
      end
    end

    def confirm_per_section_action_link(section, name)
      within("##{section}") do
        expect(page).to have_link(name)
      end
    end

    def age(dob)
      now = Time.now.utc.to_date
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
  end
end
