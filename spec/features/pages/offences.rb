module Page
  class Offences < Base
    def complete_form(options)
      fill_current_offences(options[:current_offences])

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
  end
end
