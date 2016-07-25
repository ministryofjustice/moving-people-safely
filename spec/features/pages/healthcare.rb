module Page
  class Healthcare < Base
    def expect_summary_page_with_completed_status
      within('.status-label--complete') do
        expect(page).to have_content('Complete')
      end
    end

    def complete_forms
      fill_in_physical_healthcare
      fill_in_mental_healthcare
      fill_in_social_healthcare
      fill_in_allergies
      fill_in_healthcare_needs
      fill_in_transport
      fill_in_medical_contact
    end

    def fill_in_physical_healthcare
      choose 'physical_physical_issues_yes'
      fill_in 'physical[physical_issues_details]', with: 'Back pain'
      click_button 'Save and continue'
    end

    def fill_in_mental_healthcare
      choose 'mental_mental_illness_yes'
      fill_in 'mental[mental_illness_details]', with: 'Depressed'
      choose 'mental_phobias_yes'
      fill_in 'mental[phobias_details]', with: 'Spiders'
      click_button 'Save and continue'
    end

    def fill_in_social_healthcare
      choose 'social_personal_hygiene_yes'
      fill_in 'social[personal_hygiene_details]', with: 'Dirty guy'
      choose 'social_personal_care_yes'
      fill_in 'social[personal_care_details]', with: 'Not taking care'
      click_button 'Save and continue'
    end

    def fill_in_allergies
      choose 'allergies_allergies_yes'
      fill_in 'allergies[allergies_details]', with: 'Nuts'
      click_button 'Save and continue'
    end

    def fill_in_healthcare_needs
      choose 'needs_dependencies_yes'
      fill_in 'needs[dependencies_details]', with: 'Heroin'
      choose 'needs_has_medications_yes'
      fill_in 'Description', with: 'Aspirin'
      fill_in 'Administration', with: 'Once a day'
      select 'Detainee', from: 'Carrier'
      click_button 'Save and continue'
    end

    def fill_in_transport
      choose 'transport_mpv_yes'
      fill_in 'transport[mpv_details]', with: 'Wheel chair'
      click_button 'Save and continue'
    end

    def fill_in_medical_contact
      fill_in 'Healthcare professional', with: 'Doctor Robert'
      fill_in 'Contact number', with: '079876543'
      click_button 'Save and continue'
    end
  end
end
