module Page
  class Healthcare < Base
    def expect_summary_page_with_completed_status
      within('.status-label--complete') do
        expect(page).to have_content('Complete')
      end
    end

    def complete_forms(healthcare)
      @hc = healthcare
      continue_from_intro
      fill_in_physical_healthcare
      fill_in_mental_healthcare
      fill_in_transport
      fill_in_healthcare_needs
      fill_in_dependencies
      fill_in_allergies
      fill_in_social_healthcare
      fill_in_medical_contact
    end

    def continue_from_intro
      click_link 'Continue'
    end

    def fill_in_physical_healthcare
      fill_in_optional_details('Do they have physical health needs that might affect them while they are out of prison?', @hc, :physical_issues)
      click_button 'Save and continue'
    end

    def fill_in_mental_healthcare
      fill_in_optional_details('Do they have mental health needs that might affect them while they are out of prison?', @hc, :mental_illness)
      click_button 'Save and continue'
    end

    def fill_in_social_healthcare
      fill_in_optional_details('Will they need help with personal tasks while they are out of prison?', @hc, :personal_care)
      click_button 'Save and continue'
    end

    def fill_in_allergies
      fill_in_optional_details('Do they have any known allergies or intolerances?', @hc, :allergies)
      click_button 'Save and continue'
    end

    def fill_in_healthcare_needs
      if @hc.has_medications == 'yes'
        choose 'needs_has_medications_yes'
        @hc.medications.each_with_index do |med, i|
          add_medication unless i == 0
          fill_in_medication(med, i)
        end
      else
        choose 'needs_has_medications_no'
      end
      save_and_continue
    end

    def fill_in_dependencies
      fill_in_optional_details('Do they have any addictions or dependencies that might affect them while they are out of prison?', @hc, :dependencies)
      save_and_continue
    end

    def add_medication
      click_button 'Add another medicine'
    end

    def fill_in_medication(med, i)
      el = all('.multiple-wrapper').to_a[i]
      within(el) do
        fill_in 'Medicine', with: med.description
        fill_in 'How is it given', with: med.administration
        fill_in 'Dosage', with: med.dosage
        fill_in 'When is it given?', with: med.when_given
        within_fieldset('Who will carry the medicine?') do
          choose med.carrier.titlecase
        end
      end
    end

    def fill_in_transport
      fill_in_optional_details('Do they need to travel in a special vehicle?', @hc, :mpv)
      click_button 'Save and continue'
    end

    def fill_in_medical_contact
      fill_in 'Medical contact', with: @hc.contact_number
      click_button 'Save and continue'
    end
  end
end
