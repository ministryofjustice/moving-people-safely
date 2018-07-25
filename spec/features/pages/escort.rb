module Page
  class Escort < Base
    def confirm_header_details(detainee)
      within('header') do
        detainee_detail = "#{detainee.prison_number}: #{detainee.surname}, #{detainee.forenames}"
        expect(page).to have_content(detainee_detail)
      end

      confirm_risk_flags(detainee.risk)
    end

    def confirm_all_alerts_as_inactive
      within('.alerts-table') do
        %i[not_for_release acct_status rule_45 e_list csra].each do |alert|
          expect(page).to have_css("##{alert}_header.alert-off")
        end
      end
    end

    def confirm_alert_as_inactive(attr)
      within(".flag-inactive##{attr}") do
        expect(page).to have_content I18n.t("escort.alerts.#{attr}")
      end
    end

    def confirm_alert_as_active(attr)
      within(".flag-active##{attr}") do
        expect(page).to have_content I18n.t("escort.alerts.#{attr}")
      end
    end

    def confirm_alert_not_present(attr)
      within('.flag') do
        expect(page).to_not have_content I18n.t("escort.alerts.#{attr}")
      end
    end

    def confirm_move_info(move, options = {})
      within('#move') do
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
      within('#detainee') do
        expect(page).not_to have_link('Edit')
      end
    end

    def confirm_read_only_move_details
      within('#move') do
        expect(page).not_to have_link('Edit')
      end
    end

    def confirm_detainee_details(detainee, location = :prison)
      within('#detainee') do
        expect(page).to have_content detainee.prison_number
        expect(page).to have_content detainee.date_of_birth.strftime('%d %b %Y')
        expect(page).to have_content detainee.nationalities
        expect(page).to have_content detainee.gender[0].upcase
        expect(page).to have_content detainee.pnc_number
        expect(page).to have_content detainee.cro_number
        expect(page).to have_content detainee.aliases
        expect(page).to have_content age(detainee.date_of_birth)
        expect(page).to have_content detainee.security_category if location == :prison
      end
    end

    def confirm_healthcare_status(expected_status='Complete')
      within('#healthcare') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_healthcare_labels(location = :prison)
      labels = ['Medical contact', 'Custody suite contact']
      labels.reverse! unless location == :prison

      within('#healthcare') do
        expect(page).to have_content(labels.first)
        expect(page).not_to have_content(labels.last)
      end
    end

    def confirm_risk_status(expected_status='Complete')
      within('#risk') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_offences_status(expected_status='Complete')
      within('#offences') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_offence_details(offences_data)
      within('#offences') do
        offences_data[:offences].each do |offence|
          expect(page).to have_content(offence.fetch(:name))
        end
      end
    end

    def confirm_no_offences
      within('#offences') do
        expect(page).to have_content('None')
      end
    end

    def confirm_offences(expected_offences)
      within('#offences') do
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

    def click_approve
      click_link 'Approve PER'
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

    def confirm_not_cancellable
      expect(page).not_to have_link('Cancel PER')
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
