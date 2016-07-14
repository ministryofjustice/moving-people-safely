require 'rails_helper'

RSpec.feature 'searching for a prisoner', type: :feature do
  context 'with a valid prison number' do
    scenario 'prisoner not present in MPS' do
      login
      search_with_valid_prison_number
      expect_no_results
    end

    scenario 'prisoner present with a future move' do
      escort = create_escort_with_detainee_and_future_move
      login
      search_with_valid_prison_number(escort.detainee.prison_number)
      expect(page).to have_link('View profile', href: profile_path(escort))
      expect_result_with_move(escort.move)
    end

    scenario 'prisoner present with a past move' do
      escort = create_escort_with_detainee_and_past_move
      login
      search_with_valid_prison_number(escort.detainee.prison_number)
      expect(page).to have_link('Add new move', href: move_information_path(escort))
      expect_result_with_move(escort.move)
    end

    scenario 'prisoner present with no move' do
      escort = create_escort_with_detainee_and_no_move
      login
      search_with_valid_prison_number(escort.detainee.prison_number)
      expect_result_with_no_move(escort)
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
    expect(page).to have_button('Create new profile')
  end

  def expect_error_message
    expect(page).to have_content("The prison number 'invalid-prison-number' inserted is not valid")
  end

  def expect_result_with_move(move)
    expect(page).to have_content(move.detainee.prison_number).
      and have_content(move.detainee.surname).
      and have_content(move.detainee.date_of_birth.strftime('%d %b %Y')).
      and have_content(move.to).
      and have_content(move.date.strftime('%d %b %Y'))
  end

  def expect_result_with_no_move(escort)
    expect(page).to have_link('Add new move', href: move_information_path(escort))
    expect(page).to have_content(escort.detainee.prison_number).
      and have_content(escort.detainee.surname)
  end

  def create_escort_with_detainee_and_future_move
    create :escort, :with_future_move
  end

  def create_escort_with_detainee_and_past_move
    create :escort, :with_past_move
  end

  def create_escort_with_detainee_and_no_move
    create :escort, move: nil
  end
end
