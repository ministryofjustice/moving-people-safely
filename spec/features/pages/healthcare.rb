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
      fill_in_optional_details('Physical health needs?', @hc, :physical_issues)
      click_button 'Save and continue'
    end

    def fill_in_mental_healthcare
      fill_in_optional_details('Mental health issues?', @hc, :mental_illness)
      fill_in_optional_details('Phobias?', @hc, :phobias)
      click_button 'Save and continue'
    end

    def fill_in_social_healthcare
      fill_in_optional_details('Personal hygiene issues?', @hc, :personal_hygiene)
      fill_in_optional_details('Personal care issues?', @hc, :personal_care)
      click_button 'Save and continue'
    end

    def fill_in_allergies
      fill_in_optional_details('Allergies?', @hc, :allergies)
      click_button 'Save and continue'
    end

    def fill_in_healthcare_needs
      fill_in_optional_details('Any dependencies or history of misuse?', @hc, :dependencies)
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

    def add_medication
      click_button 'Add medication'
    end

    def fill_in_medication(med, i)
      el = all('#medications .optional-section').to_a[i]
      within(el) do
        fill_in 'What is it?', with: med.description
        fill_in 'How is it given?', with: med.administration
        select med.carrier.titlecase, from: 'Who carries it?'
      end
    end

    def fill_in_transport
      fill_in_optional_details('Requires MPV?', @hc, :mpv)
      click_button 'Save and continue'
    end

    def fill_in_medical_contact
      fill_in 'Healthcare professional', with: @hc.healthcare_professional
      fill_in 'Contact number', with: @hc.contact_number
      click_button 'Save and continue'
    end
  end
end
