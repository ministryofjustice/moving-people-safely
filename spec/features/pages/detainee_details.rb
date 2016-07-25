module Page
  class DetaineeDetails < Base
    def complete_form(detainee)
      expect(find('p.prison_number').text).to eql detainee.prison_number

      fill_in 'Surname', with: detainee.surname
      fill_in 'Forename(s)', with: detainee.forenames
      fill_in 'Date of birth', with: detainee.date_of_birth
      fill_in 'Nationalities', with: detainee.nationalities
      choose detainee.gender.titlecase
      fill_in 'PNC number', with: detainee.pnc_number
      fill_in 'CRO number', with: detainee.cro_number
      fill_in 'Aliases', with: detainee.aliases

      click_button 'Save and continue'
    end
  end
end
