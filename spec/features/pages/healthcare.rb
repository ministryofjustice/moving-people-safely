module Page
  class Healthcare < Base
    def expect_summary_page_with_completed_status
      within('.status-label--complete') do
        expect(page).to have_content('Complete')
      end
    end

    def complete_forms(healthcare)
      @hc = healthcare
      fill_in_physical_healthcare
      fill_in_mental_healthcare
      fill_in_social_healthcare
      fill_in_allergies
      fill_in_healthcare_needs
      fill_in_transport
      fill_in_medical_contact
    end

    def fill_in_physical_healthcare
      fill_in_optional_details('Physical issues', @hc.physical_issues, @hc.physical_issues_details)
      click_button 'Save and continue'
    end

    def fill_in_mental_healthcare
      fill_in_optional_details('Mental illness', @hc.mental_illness, @hc.mental_illness_details)
      fill_in_optional_details('Phobias', @hc.phobias, @hc.phobias_details)
      click_button 'Save and continue'
    end

    def fill_in_social_healthcare
      fill_in_optional_details('Personal hygiene', @hc.personal_hygiene, @hc.personal_hygiene_details)
      fill_in_optional_details('Personal care', @hc.personal_care, @hc.personal_care_details)
      click_button 'Save and continue'
    end

    def fill_in_allergies
      fill_in_optional_details('Allergies', @hc.allergies, @hc.allergies_details)
      click_button 'Save and continue'
    end

    def fill_in_healthcare_needs
      fill_in_optional_details('Dependencies', @hc.dependencies, @hc.dependencies_details)
      choose 'needs_has_medications_yes'
      fill_in 'Description', with: 'Aspirin'
      fill_in 'Administration', with: 'Once a day'
      select 'Detainee', from: 'Carrier'
      save_and_continue
    end

    def fill_in_transport
      fill_in_optional_details('MPV', @hc.mpv, @hc.mpv_details)
      click_button 'Save and continue'
    end

    def fill_in_medical_contact
      fill_in 'Healthcare professional', with: @hc.healthcare_professional
      fill_in 'Contact number', with: @hc.contact_number
      click_button 'Save and continue'
    end
  end
end
