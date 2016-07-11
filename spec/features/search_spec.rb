require 'rails_helper'

RSpec.feature 'searching for a prisoner', type: :feature do
  context 'with a valid prison number' do
    scenario 'prisoner not present in MPS' do
      login
      search_with_valid_prison_number
      expect_no_results
    end

    scenario 'prisoner present with a future move' do
      create_escort_with_detainee_and_future_move
      login
      search_with_valid_prison_number
      expect_result_with_future_move
    end

    scenario 'prisoner present with a past move' do
      create_escort_with_detainee_and_past_move
      login
      search_with_valid_prison_number
      expect_result_with_past_move
    end

    scenario 'prisoner present with no move' do
      create_escort_with_detainee_and_no_move
      login
      search_with_valid_prison_number
      expect_result_with_no_move
    end
  end

  scenario 'with an invalid prison number' do
    login
    search_with_invalid_prison_number
    expect_error_message
  end

  def search_with_valid_prison_number
    fill_in 'search_prison_number', with: 'A1234BC'
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

  def expect_result_with_future_move
    date = 3.days.from_now.to_date.to_s(:humanized)
    expect(page).to have_link('View profile', href: profile_path(escort))
    expect(page).to have_content('A1234BC').
      and have_content('Trump Donald').
      and have_content('14 Jun 1946').
      and have_content('Alcatraz').
      and have_content(date)
  end

  def expect_result_with_past_move
    date = 1.weeks.ago.to_date.to_s(:humanized)
    expect(page).to have_link('Add new move', href: move_information_path(escort))
    expect(page).to have_content('A1234BC').
      and have_content('Trump Donald').
      and have_content('14 Jun 1946').
      and have_content('Alcatraz').
      and have_content(date)
  end

  def expect_result_with_no_move
    expect(page).to have_link('Add new move', href: move_information_path(escort))
    expect(page).to have_content('A1234BC').
      and have_content('Trump Donald').
      and have_content('None')
  end

  def create_escort_with_detainee_and_future_move
    create :escort
  end

  def create_escort_with_detainee_and_past_move
    create :escort, :with_past_move
  end

  def create_escort_with_detainee_and_no_move
    create :escort, move: nil
  end

  def escort
    Escort.last
  end
end
