module Page
  class Offences < Base
    def complete_form(options)
      fill_offences(options[:offences])

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

    def add(description:, case_reference:, append: true)
      click_button 'Add another offence' if append
      expect(page).to have_content('This is used to associate the detainee to their case.')
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

    def insert_into_row(row, description, case_reference)
      within row do
        page.fill_in "Offence", with: description
        page.fill_in "Case reference", with: case_reference
      end
    end

    def fill_offences(offences)
      return unless offences && !offences.empty?
      append = false

      offences.each do |offence|
        add(description: offence[:name], case_reference: offence[:case_reference], append: append)
        append = true
      end
    end
  end
end
