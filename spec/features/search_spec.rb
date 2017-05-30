require 'feature_helper'

RSpec.feature 'searching for a prisoner', type: :feature do
  context 'with a valid prison number' do
    scenario 'prisoner not present in MPS' do
      login
      search_with_valid_prison_number
      expect_no_results
    end

    scenario 'prisoner present with an active escort' do
      prison_number = 'A1324BC'
      detainee = create(:detainee, prison_number: prison_number)
      move = create(:move)
      escort = create(:escort, prison_number: prison_number, detainee: detainee, move: move)

      login
      search_with_valid_prison_number(prison_number)
      expect(page).to have_link('Continue PER', href: escort_path(escort))
      expect_result_with_move(detainee, move)
    end

    scenario 'prisoner present with a previously issued escort' do
      prison_number = 'A1324BC'
      detainee = create(:detainee, prison_number: prison_number)
      move = create(:move)
      create(:escort, :issued, prison_number: prison_number, detainee: detainee, move: move)

      login
      search_with_valid_prison_number(prison_number)
      expect(page).to have_button('Start new PER')
      expect_result_with_move(detainee, move)
    end

    scenario 'prisoner present with no move' do
      prison_number = 'A1324BC'
      detainee = create(:detainee, prison_number: prison_number)
      create(:escort, prison_number: prison_number, detainee: detainee)

      login
      search_with_valid_prison_number(prison_number)
      expect_result_with_no_move(detainee)
    end
  end

  scenario 'with an invalid prison number' do
    login
    search_with_invalid_prison_number
    expect_error_message
  end

  def search_with_valid_prison_number(prison_number = 'A1234BC')
    fill_in 'search_prison_number', with: prison_number
    click_button 'Search'
  end

  def search_with_invalid_prison_number
    fill_in 'search_prison_number', with: 'invalid-prison-number'
    click_button 'Search'
  end

  def expect_no_results
    expect(page).to have_button('Start new PER')
  end

  def expect_error_message
    expect(page).to have_content("The prison number 'INVALID-PRISON-NUMBER' is not valid")
  end

  def expect_result_with_move(detainee, move)
    expect(page).to have_content(detainee.prison_number).
      and have_content(detainee.surname).
      and have_content(detainee.date_of_birth.strftime('%d %b %Y')).
      and have_content(move.to).
      and have_content(move.date.strftime('%d %b %Y'))
  end

  def expect_result_with_no_move(detainee)
    expect(page).to have_link('Continue PER')
    expect(page).to have_content(detainee.prison_number).
      and have_content(detainee.surname)
  end
end
