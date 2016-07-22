class DetaineeDetailsPage < SitePrism::Page
  set_url "/:id/detainee-details"
  element :prison_number, 'p.prison_number'

  def complete_form(detainee)
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
