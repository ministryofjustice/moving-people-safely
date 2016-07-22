class ProfilePage < SitePrism::Page
  include Capybara::DSL
  include RSpec::Matchers

  set_url '/:id/profile'

  def confirm_move_info(move)
    Capybara.within('.move-information') do
      # expect(page).to have_link('Edit', href: move_information_path(escort))
      expect(page).to have_content move.to
      expect(page).to have_content move.date.strftime('%d %b %Y')
      expect(page).to have_content move.reason_details
      expect(page).to have_content('Hospital, Court')
      expect(page).to have_content('Dentist, Tribunal')
    end
  end

  def confirm_detainee_details(detainee)
    Capybara.within('#personal-details') do
      # expect(page).to have_link('Edit', href: detainee_details_path(escort))
      expect(page).to have_content detainee.prison_number
      expect(page).to have_content detainee.date_of_birth.strftime('%d %b %Y')
      expect(page).to have_content detainee.nationalities
      expect(page).to have_content detainee.gender[0].upcase
      expect(page).to have_content detainee.pnc_number
      expect(page).to have_content detainee.cro_number
      expect(page).to have_content detainee.aliases
      expect(page).to have_content age(detainee.date_of_birth)
    end
  end

  def edit_healthcare
    Capybara.within('#healthcare') do
      click_link 'Edit'
    end
  end

  def edit_risk
    Capybara.within('#risk') do
      click_link 'Edit'
    end
  end

  private

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
