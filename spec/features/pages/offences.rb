module Page
  class Offences < Base
    def complete_form(data, role=:prison)
      fill_offences(data[:offences], role)

      save_and_continue
    end

    def confirm_status(expected_status)
      within('#offences-status') do
        expect(page).to have_content(expected_status)
      end
    end

    def update(index:, description:, case_reference:)
      offence_row = all(".multiple-wrapper")[index]
      insert_into_row(offence_row, description, case_reference)
    end

    def add(description:, case_reference:)
      click_button 'Add another'
      offence_row = all(".multiple-wrapper").last
      insert_into_row(offence_row, description, case_reference)
    end

    def confirm_api_unavailable_warning
      expect(page).
        to have_content("Offences aren't available right now, please try again or fill in the offences below")
    end

    def confirm_read_only
      expect(page).not_to have_selector('form.edit_offences')
      expect(page).to have_selector('#offences-table')
    end

    private

    def insert_into_row(row, description, case_reference, role=:prison)
      within row do
        page.fill_in "Offence", with: description

        if role == :police
          page.fill_in "Unique reference number", with: case_reference
        else
          page.fill_in "Case reference", with: case_reference
        end
      end
    end

    def fill_offences(offences, role)
      return unless offences && offences.any?

      offences.each_with_index do |offence, index|
        offence_row = all(".multiple-wrapper").last

        insert_into_row(offence_row, offence.fetch(:name),
          offence.fetch(:case_reference), role)

        click_button 'Add another' unless index >= offences.size - 1
      end
    end
  end
end
