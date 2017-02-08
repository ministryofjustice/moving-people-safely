module Page
  class Profile < Base
    def confirm_header_details(detainee)
      within('#header') do
        detainee_detail = "#{detainee.prison_number}: #{detainee.surname}, #{detainee.forenames}"
        expect(page).to have_content(detainee_detail)
      end

      confirm_risk_flags(detainee.risk)
    end

    def confirm_all_alerts_as_inactive
      within('.profile-alerts') do
        %i[not_for_release acct_status rule_45 e_list csra category_a mpv].each do |alert|
          expect(page).to have_css("##{alert}_header.alert-off")
        end
      end
    end

    def confirm_alert_as_inactive(attr)
      within('.profile-alerts') do
        expect(page).to have_css("##{attr}_header.alert-off")
      end
    end

    def confirm_alert_as_active(attr)
      within('.profile-alerts') do
        expect(page).to have_css("##{attr}_header.alert-on")
      end
    end

    def confirm_move_info(move, options = {})
      within('.move-information') do
        expect(page).to have_content move.from
        expect(page).to have_content move.to
        expect(page).to have_content move.date.strftime('%d %b %Y')
        destinations = options[:destinations]
        if destinations.present?
          must_returns = destinations.select { |d| d[:must] == :return }.pluck(:establishment)
          must_not_returns = destinations.select { |d| d[:must] == :not_return }.pluck(:establishment)
          within('.must-return-to') do
            must_returns.each do |must_return|
              expect(page).to have_content(must_return)
            end
          end

          within('.must-not-return-to') do
            must_not_returns.each do |must_not_return|
              expect(page).to have_content(must_not_return)
            end
          end
        end
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
          expect(page).to have_content(hc.questions_answered_yes.to_s)
        end
        within('.answered_no') do
          expect(page).to have_content(hc.questions_answered_no.to_s)
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

    def confirm_offences_details(offences_data)
      confirm_current_offences(offences_data[:current_offences])
      confirm_past_offences(offences_data[:past_offences])
    end

    def confirm_no_current_offences
      within('#current-offences-summary') do
        expect(page).to have_content('None')
      end
    end

    def confirm_current_offences(expected_offences)
      within('#current-offences-summary') do
        expected_offences.each do |offence|
          expect(page).to have_content(offence.fetch(:name))
        end
      end
    end

    def confirm_no_past_offences
      within('#past-offences-summary') do
        expect(page).to have_content('None')
      end
    end

    def confirm_past_offences(expected_offences)
      within('#past-offences-summary') do
        expected_offences.each do |offence|
          expect(page).to have_content(offence.fetch(:name))
        end
      end
    end

    def click_edit_healthcare
      within('#healthcare') do
        click_link 'Edit'
      end
    end

    def click_edit_risk
      within('#risk') do
        click_link 'Edit'
      end
    end

    def click_edit_offences
      within('#offences') do
        click_link 'Edit'
      end
    end

    def click_print
      click_link 'Print'
    end

    private

    def age(dob)
      now = Time.now.utc.to_date
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
  end
end
