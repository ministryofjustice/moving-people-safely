require 'rails_helper'

RSpec.feature 'searching for a prisoner', type: :feature do
  scenario 'with a valid prison number but prisoner not in present in MPS' do
    login
    search_with_valid_prison_number
    expect_no_results
  end

  scenario 'with a valid prison number and prisoner present in MPS' do
    create_escort_with_detainee_and_move
    login
    search_with_valid_prison_number
    expect_results
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

  def expect_results
    expect(page).to have_link('Review profile', href: profile_path(escort))
    expect(page).to have_content('A1234BC').
      and have_content('Alcatraz').
      and have_content('Trump Donald').
      and have_content('14 Jun 1946').
      and have_content('10 Jul 2016')
  end

  def create_escort_with_detainee_and_move
    Escort.create.tap do |e|
      e.create_detainee(
        prison_number: 'A1234BC',
        forenames: 'Donald',
        surname: 'Trump',
        date_of_birth: Date.civil(1946, 6, 14)
      )
      e.create_move(to: 'Alcatraz', date: Date.civil(2016, 7, 10))
    end
  end

  def escort
    Escort.last
  end
end
