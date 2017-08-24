module Page
  class Detainee < Base
    def complete_form(detainee)
      expect(find('p.prison_number').text).to eql detainee.prison_number

      fill_in 'Surname', with: detainee.surname
      fill_in 'First name(s)', with: detainee.forenames
      fill_in 'Date of birth', with: detainee.date_of_birth
      fill_in 'Nationalities', with: detainee.nationalities
      choose detainee.gender.titlecase
      fill_in 'Religion', with: detainee.religion
      fill_in 'Ethnicity', with: detainee.ethnicity
      fill_in 'PNC number', with: detainee.pnc_number
      fill_in 'CRO number', with: detainee.cro_number
      fill_in 'Aliases', with: detainee.aliases

      save_and_continue
    end

    def assert_unprefilled_form(prison_number = nil)
      if prison_number
        expect(prison_number_input).to eq(nil)
      else
        expect(prison_number_input.value).to be_blank
      end
      expect(surname_input.value).to be_blank
      expect(forenames_input.value).to be_blank
      expect(dob_input.value).to be_blank
      expect(nationalities_input.value).to be_blank
      expect(religion_input.value).to be_blank
      expect(ethnicity_input.value).to be_blank
      expect(gender_input).to eq(nil)
      expect(pnc_number_input.value).to be_blank
      expect(cro_number_input.value).to be_blank
      expect(aliases_input.value).to be_blank
    end

    def assert_prefilled_form(options)
      expect(prison_number_input).to eq(nil)
      expect(surname_input.value).to eq(options.fetch(:surname))
      expect(forenames_input.value).to eq(options.fetch(:forenames))
      expect(dob_input.value).to eq(options.fetch(:date_of_birth))
      expect(nationalities_input.value).to eq(options.fetch(:nationalities))
      expect(gender_input.value).to eq(options.fetch(:gender))
      expect(pnc_number_input.value).to eq(options.fetch(:pnc_number))
      expect(cro_number_input.value).to eq(options.fetch(:cro_number))
      expect(aliases_input.value).to eq('')
    end

    def assert_form_with_image_placeholder
      expect(page).not_to have_css('.detainee-image')
      expect(page).to have_css('.no-image')
    end

    def assert_form_with_detainee_image
      expect(page).to have_css('.detainee-image')
    end

    private

    def prison_number_input
      find('#detainee_prison_number')
    rescue Capybara::ElementNotFound
      nil
    end

    def surname_input
      find('#detainee_surname')
    end

    def forenames_input
      find('#detainee_forenames')
    end

    def dob_input
      find('#detainee_date_of_birth')
    end

    def nationalities_input
      find('#detainee_nationalities')
    end

    def religion_input
      find('#detainee_religion')
    end

    def ethnicity_input
      find('#detainee_ethnicity')
    end

    def pnc_number_input
      find('#detainee_pnc_number')
    end

    def cro_number_input
      find('#detainee_cro_number')
    end

    def aliases_input
      find('#detainee_aliases')
    end

    def gender_input
      find(:radio_button, 'detainee[gender]', checked: true)
    rescue Capybara::ElementNotFound
      nil
    end
  end
end
