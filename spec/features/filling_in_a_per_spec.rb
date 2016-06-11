require 'rails_helper'

RSpec.feature 'filling in a PER', type: :feature do
  scenario 'adding a new escort and filling it in' do
    visit '/'

    search_prisoner
    create_new_detainee_profile
    expect_prison_number_to_be_autofilled

    fill_in_detainee_details
    save

    expect_to_be_sent_to_profile_page

    expect_profile_page_to_have_links

    go_to_move_information_page
    fill_in_move_information
    save

    expect_to_be_sent_to_profile_page
  end

  def search_prisoner
    fill_in 'search_prison_number', with: 'A1234BC'
    click_button 'Search'
  end

  def expect_prison_number_to_be_autofilled
    expect(page).to have_content 'Prison numberA1234BC'
  end

  def create_new_detainee_profile
    click_button 'Create new profile'
  end

  def fill_in_detainee_details
    fill_in 'Surname', with: 'Trump'
    fill_in 'Forename(s)', with: 'Donald'
    fill_in 'Date of birth', with: '10/09/1985'
    fill_in 'Nationalities', with: 'American'
    choose 'Male'
  end

  def expect_profile_page_to_have_links
    expect(page).to have_link('Homepage', href: root_path)
    expect(page).to have_link('Detainee details', href: detainee_details_path(escort))
    expect(page).to have_link('Move information', href: move_information_path(escort))
  end

  def go_to_move_information_page
    click_link 'Move information'
  end

  def fill_in_move_information
    fill_in 'From', with: 'Some prison'
    fill_in 'To', with: 'Some court'
    fill_in 'Date', with: '12/09/2016'
    choose 'Trial'
    choose 'No'
  end

  def expect_to_be_sent_to_profile_page
    expect(current_path).to eq profile_path(escort)
  end

  def save
    click_button 'Save'
  end

  def escort
    Escort.last
  end
end
