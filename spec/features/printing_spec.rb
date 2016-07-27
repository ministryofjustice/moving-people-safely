require 'feature_helper'

RSpec.feature 'printing a PER', type: :feature do
  scenario 'user prints a completed PER' do
    escort = create :escort
    prison_number = escort.detainee.prison_number

    login
    print_PER(prison_number)

    within("tr#prison_number_#{prison_number}") do
      assert has_no_link? "#{prison_number}"
      assert has_content? 'Issued'
      assert has_link? 'Reprint'
    end
  end

  def print_PER(prison_number)
    within("tr#prison_number_#{prison_number}") do
      click_link 'Print'
    end
  end
end
