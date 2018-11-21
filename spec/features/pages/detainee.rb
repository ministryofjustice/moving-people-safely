module Page
  class Detainee < Base
    def complete_form(detainee, options = {})
      location = options.fetch(:location, :prison)

      expect(find('p.prison_number').text).to eql detainee.prison_number if location == :prison
      fill_in 'Prison number', with: detainee.prison_number if location == :police

      fill_in 'Surname', with: detainee.surname
      fill_in 'First name(s)', with: detainee.forenames
      fill_in 'Date of birth', with: detainee.date_of_birth
      fill_in 'Nationalities', with: detainee.nationalities
      choose detainee.gender.titlecase
      fill_in 'Religion', with: detainee.religion if location == :prison
      select 'W1', from: 'auto_ethnicity'
      fill_in 'PNC number', with: detainee.pnc_number
      fill_in 'CRO number', with: detainee.cro_number
      fill_in 'Aliases', with: detainee.aliases
      fill_in 'Preferred language', with: detainee.language if location == :prison
      within('#interpreter_required') do
        choose detainee.interpreter_required.humanize
        fill_in 'detainee[language]', with: detainee.language if location == :police
        fill_in('detainee[interpreter_required_details]', with: detainee.interpreter_required) if location == :police
      end
      if location == :prison
        within('#peep') do
          choose detainee.peep.humanize
          fill_in 'detainee_peep_details', with: detainee.peep_details
        end
        unless detainee.security_category.blank?
          fill_in 'Security category', with: detainee.security_category
        end
      end
      fill_in 'Diet', with: detainee.diet

      save_and_continue
    end
  end
end
