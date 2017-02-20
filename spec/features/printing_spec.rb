require 'feature_helper'

RSpec.feature 'printing a PER', type: :feature do
  scenario 'user prints a completed PER' do
    detainee = FactoryGirl.create(:detainee)
    move = FactoryGirl.create(:move, :confirmed, detainee: detainee)

    login
    visit detainee_path(detainee)
    print_per
    move_print_page.assert_detainee_details(detainee)
  end

  def print_per
    within(".actions") do
      click_link 'Print'
    end
  end
end
