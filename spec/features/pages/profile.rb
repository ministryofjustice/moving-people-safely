module Page
  class Profile < Base
    def confirm_move_info(move)
      Capybara.within('.move-information') do
        # expect(page).to have_link('Edit', href: move_information_path(escort))
        expect(page).to have_content move.to
        expect(page).to have_content move.date.strftime('%d %b %Y')
        expect(page).to have_content move.reason_details
        expect(page).to have_content('Hospital, Court')
        expect(page).to have_content('Dentist, Tribunal')
      end
    end

    def confirm_detainee_details(detainee)
      Capybara.within('#personal-details') do
        # expect(page).to have_link('Edit', href: detainee_details_path(escort))
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

    def confirm_healthcare_details
      Capybara.within('#healthcare') do
        expect(page).to have_content('Complete')
        within('.answered_yes') do
          expect(page).to have_content('9')
        end
        within('.answered_no') do
          expect(page).to have_content('0')
        end
      end
    end

    def confirm_risk_details
      within('#risk') do
        expect(page).to have_content('Complete')
        within('.answered_yes') do
          expect(page).to have_content('22')
        end
        within('.answered_no') do
          expect(page).to have_content('1')
        end
      end
    end

    # TODO: reference a model
    def confirm_offences_details
      Capybara.within('#offences') do
        expect(page).to have_content('Burglary')
        expect(page).to have_content('Attempted murder')
        expect(page).to have_content('Arson')
        expect(page).to have_content('Armed robbery')
      end
    end

    def click_edit_healthcare
      Capybara.within('#healthcare') do
        click_link 'Edit'
      end
    end

    def click_edit_risk
      Capybara.within('#risk') do
        click_link 'Edit'
      end
    end

    def click_edit_offences
      Capybara.within('#offences') do
        click_link 'Edit'
      end
    end

    private

    def age(dob)
      now = Time.now.utc.to_date
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
  end
end
