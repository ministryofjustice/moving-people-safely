module Page
  class Offences < Base
    def complete_form(options)
      if options[:release_date]
        fill_in 'offences[release_date]', with: options[:release_date]
      end

      if options[:not_for_release]
        check 'offences[not_for_release]'
        fill_in 'offences_not_for_release_details', with: options.fetch(:not_for_release_details)
      end

      fill_current_offences(options[:current_offences])
      fill_past_offences(options[:past_offences])

      save_and_continue
    end

    def confirm_status(expected_status)
      within('header h3') do
        expect(page).to have_content(expected_status)
      end
    end

    private

    def fill_current_offences(offences)
      return unless offences && !offences.empty?
      offences.each_with_index do |offence, index|
        field_prefix = 'offences_current_offences_attributes'
        fill_in "#{field_prefix}_#{index}_offence", with: offence.fetch(:name)
        if offence[:case_reference]
          fill_in "#{field_prefix}_#{index}_case_reference", with: offence[:case_reference]
        end
        click_button 'Add offence' unless index >= offences.size - 1
      end
    end

    def fill_past_offences(offences)
      return unless offences && !offences.empty?
      choose 'Yes'
      offences.each_with_index do |offence, index|
        field_prefix = 'offences_past_offences_attributes'
        field_name = "#{field_prefix}_#{index}_offence"
        click_button 'Add past offence' unless first("##{field_name}")
        fill_in field_name, with: offence.fetch(:name)
      end
    end
  end
end
