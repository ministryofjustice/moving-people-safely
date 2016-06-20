require 'rails_helper'

RSpec.feature 'filling in a PER', type: :feature do
  scenario 'adding a new escort and filling it in' do
    login

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

    go_to_healthcare_page
    fill_in_physical_healthcare
    save_and_continue
    fill_in_mental_healthcare
    save_and_continue
    fill_in_social_healthcare
    save_and_continue
    fill_in_allergies
    save_and_continue
    fill_in_healthcare_needs
    save_and_continue
    fill_in_transport
    save_and_continue
    fill_in_medical_contact
    save_and_continue

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

  def go_to_healthcare_page
    click_link 'Healthcare'
  end

  def fill_in_physical_healthcare
    choose 'physical_physical_issues_yes'
    fill_in 'physical[physical_issues_details]', with: 'Back pain'
  end

  def fill_in_mental_healthcare
    choose 'mental_mental_illness_yes'
    fill_in 'mental[mental_illness_details]', with: 'Depressed'
    choose 'mental_phobias_yes'
    fill_in 'mental[phobias_details]', with: 'Spiders'
  end

  def fill_in_social_healthcare
    choose 'social_personal_hygiene_yes'
    fill_in 'social[personal_hygiene_details]', with: 'Dirty guy'
    choose 'social_personal_care_yes'
    fill_in 'social[personal_care_details]', with: 'Not taking care'
  end

  def fill_in_allergies
    choose 'allergies_allergies_yes'
    fill_in 'allergies[allergies_details]', with: 'Nuts'
  end

  def fill_in_healthcare_needs
    choose 'needs_dependencies_yes'
    fill_in 'needs[dependencies_details]', with: 'Heroin'
    choose 'needs_medication_yes'
    fill_in 'Description', with: 'Aspirin'
    fill_in 'Administration', with: 'Once a day'
    select 'detainee', from: 'Carrier'
  end

  def fill_in_transport
    choose 'transport_mpv_yes'
    fill_in 'transport[mpv_details]', with: 'Wheel chair'
  end

  def fill_in_medical_contact
    fill_in 'Clinician name', with: 'Doctor Robert'
    fill_in 'Contact number', with: '079876543'
  end

  def save_and_continue
    click_button 'Save and continue'
  end

  def escort
    Escort.last
  end
end
