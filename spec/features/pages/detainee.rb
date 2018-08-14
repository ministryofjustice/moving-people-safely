module Page
  class Detainee < Base
    def complete_form(detainee, origin = :prison)
      expect(find('p.prison_number').text).to eql detainee.prison_number if origin == :prison
      fill_in 'Prison number', with: detainee.prison_number if origin == :police

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
      fill_in 'Preferred language', with: detainee.language
      within('#interpreter_required') do
        choose detainee.interpreter_required.humanize
        fill_in('detainee_interpreter_required_details', with: detainee.interpreter_required) if origin == :police
      end
      if origin == :prison
        within('#peep') do
          choose detainee.peep.humanize
          fill_in 'detainee_peep_details', with: detainee.peep_details
        end
        fill_in 'Security category', with: detainee.security_category
      end
      fill_in 'Diet', with: detainee.diet

      save_and_continue
    end
  end
end
