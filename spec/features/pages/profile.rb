module Page
  class Profile < Base
      def confirm_header_details(detainee)
        within('#header') do
          detainee_detail = "#{detainee.prison_number}: #{detainee.surname}, #{detainee.forenames}"
          expect(page).to have_content(detainee_detail)
          expect(page).to have_content('Serving Sentence')
          expect(page).to have_content('High CSRA') if detainee.risk.csra == 'high'
          expect(page).to have_content('Needs ACCT') if detainee.risk.open_acct == 'yes'
          expect(page).to have_content('Details for Rule 45') if detainee.risk.rule_45 == 'yes'
          expect(page).to have_content('Category A information') if detainee.risk.category_a == 'yes'
        end
      end

    def confirm_move_info(move)
      within('.move-information') do
        expect(page).to have_content move.to
        expect(page).to have_content move.date.strftime('%d %b %Y')
        expect(page).to have_content move.reason_details
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
          expect(page).to have_content(hc.questions_answered.to_s)
        end
        within('.answered_no') do
          expect(page).to have_content(hc.questions_unanswered.to_s)
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
          expect(page).to have_content risk.questions_answered
        end
        within('.answered_no') do
          expect(page).to have_content risk.questions_unanswered
        end
      end
    end

    def confirm_offences_status(expected_status='Complete')
      within('#offences') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_offences_details
      within('#offences') do
        expect(page).to have_content('Burglary')
        expect(page).to have_content('Attempted murder')
        expect(page).to have_content('Arson')
        expect(page).to have_content('Armed robbery')
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
