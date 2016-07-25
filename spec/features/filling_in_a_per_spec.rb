require 'feature_helper'

RSpec.feature 'filling in a PER', type: :feature do
  around(:each) do |example|
    travel_to(Time.new(2016, 7, 3, 9, 30, 0)) { example.run }
  end

  scenario 'adding a new escort and filling it in' do
    login

    detainee = build(:detainee)
    move = build(:move)

    dashboard.search(detainee.prison_number)
    dashboard.create_new_profile.click

    detainee_details.complete_form(detainee)
    move_details.complete_form(move)

    profile.confirm_move_info(move)
    profile.confirm_detainee_details(detainee)
    profile.click_edit_healthcare

    review_summary_page

    healthcare.complete_forms
    healthcare.expect_summary_page_with_completed_status

    visit profile_path(Escort.last)
    profile.confirm_healthcare_details
    profile.click_edit_risk

    review_summary_page

    risk.complete_forms
    risk.expect_summary_page_with_completed_status

    visit profile_path(Escort.last)
    profile.confirm_risk_details

    profile.click_edit_offences
    offences.complete_form

    visit profile_path(Escort.last)
    profile.confirm_offences_details
    expect_profile_page_to_have_header
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

  def review_summary_page
    click_button 'Confirm and save'
  end
end
