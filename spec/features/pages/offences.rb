module Page
  class Offences < Base
    def complete_form
      fill_in 'offences[release_date]', with: '05/07/2016'
      check 'offences[not_for_release]'
      fill_in 'offences_not_for_release_details', with: 'Serving Sentence'
      fill_in 'offences_current_offences_attributes_0_offence', with: 'Burglary'
      fill_in 'offences_current_offences_attributes_0_case_reference', with: 'Ref 3064'
      click_button 'Add offence'
      fill_in 'offences_current_offences_attributes_1_offence', with: 'Attempted murder'
      fill_in 'offences_current_offences_attributes_1_case_reference', with: 'Ref 7291'
      choose 'Yes'
      click_button 'Add past offence'
      fill_in 'offences_past_offences_attributes_0_offence', with: 'Arson'
      click_button 'Add past offence'
      fill_in 'offences_past_offences_attributes_1_offence', with: 'Armed robbery'

      save_and_continue
    end

    def confirm_status(expected_status)
      within('header h3') do
        expect(page).to have_content(expected_status)
      end
    end
  end
end
