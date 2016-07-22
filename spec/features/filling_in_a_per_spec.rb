require 'feature_helper'

RSpec.feature 'filling in a PER', type: :feature do
  around(:each) do |example|
    travel_to(Time.new(2016, 7, 3, 9, 30, 0)) { example.run }
  end

  scenario 'adding a new escort and filling it in' do
    app = App.new
    app.login

    detainee = build(:detainee)
    move = build(:move)

    app.dashboard.search(detainee.prison_number)
    app.dashboard.create_new_profile.click

    expect(app.detainee_details.prison_number.text).to eql detainee.prison_number

    app.detainee_details.complete_form(detainee)
    app.move_details.complete_form(move)

    app.profile.confirm_move_info(move)
    app.profile.confirm_detainee_details(detainee)

    app.profile.edit_healthcare
    app.healthcare.complete_forms

    review_summary_page

    expect_profile_page_with_completed_healthcare

    app.profile.edit_risk
    app.risk.complete_forms

    review_summary_page

    expect_profile_page_with_completed_risk

    go_to_offences_page
    fill_in_offences
    save_and_continue

    expect_profile_page_with_completed_offences

    expect_profile_page_to_have_header
  end


  def save
    click_button 'Save'
  end



  def expect_profile_page_with_completed_healthcare
    visit profile_path(escort)
    within('#healthcare') do
      expect(page).to have_content('Complete')
      within('.answered_yes') do
        expect(page).to have_content('9')
      end
      within('.answered_no') do
        expect(page).to have_content('0')
      end
    end
  end


  def expect_profile_page_with_completed_risk
    visit profile_path(escort)
    within('#risk') do
      expect(page).to have_content('Complete')
      within('.answered_yes') do
        expect(page).to have_content('22')
      end
      within('.answered_no') do
        expect(page).to have_content('1')
      end
    end
  end

  def go_to_offences_page
    within('#offences') do
      click_link 'Edit'
    end
  end

  def fill_in_offences
    fill_in 'offences[release_date]', with: '05/07/2016'
    check 'offences[not_for_release]'
    fill_in 'offences_not_for_release_details', with: 'Serving Sentence'
    fill_in 'offences_current_offences_attributes_0_offence', with: 'Burglary'
    fill_in 'offences_current_offences_attributes_0_case_reference', with: 'Ref 3064'
    click_button 'Add offence'
    fill_in 'offences_current_offences_attributes_1_offence', with: 'Attempted murder'
    fill_in 'offences_current_offences_attributes_1_case_reference', with: 'Ref 7291'
    choose 'Yes'
    click_button 'Add past offence'
    fill_in 'offences_past_offences_attributes_0_offence', with: 'Arson'
    click_button 'Add past offence'
    fill_in 'offences_past_offences_attributes_1_offence', with: 'Armed robbery'
  end

  def expect_profile_page_with_completed_offences
    within('#offences') do
      expect(page).to have_content('Complete')
      expect(page).to have_content('Burglary')
      expect(page).to have_content('Attempted murder')
      expect(page).to have_content('Arson')
      expect(page).to have_content('Armed robbery')
    end
  end

  def expect_profile_page_to_have_header
    within('#header') do
      expect(page).to have_content('A1234BC: Trump, Donald')
      expect(page).to have_content('Serving Sentence')
      expect(page).to have_content('High CSRA')
      expect(page).to have_content('Needs ACCT')
      expect(page).to have_content('Details for Rule 45')
      expect(page).to have_content('Category A information')
    end
  end

  def save
    click_button 'Save'
  end

  def save_and_continue
    click_button 'Save and continue'
  end

  def review_summary_page
    click_button 'Confirm and save'
  end

  def escort
    Escort.last
  end
end
