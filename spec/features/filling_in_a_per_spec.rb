require 'feature_helper'

RSpec.feature 'filling in a PER', type: :feature do
  scenario 'adding a new escort and filling it in' do
    login

    detainee = build(:detainee)
    move = build(:move)
    hc = build(:healthcare, :with_medications)
    r = build(:risk, :with_high_csra)

    dashboard.search(detainee.prison_number)
    dashboard.create_new_profile.click

    detainee_details.complete_form(detainee)
    move_details.complete_form(move)

    profile.confirm_move_info(move)
    profile.confirm_detainee_details(detainee)
    profile.click_edit_healthcare

    healthcare.complete_forms(hc)
    healthcare_summary.confirm_and_save

    profile.confirm_healthcare_details(hc)
    profile.click_edit_risk

    risk.complete_forms(r)
    risk_summary.confirm_and_save

    profile.confirm_risk_details(r)
    profile.click_edit_offences

    offences.complete_form
    profile.confirm_offences_details
    profile.confirm_header_details(detainee)
  end
end
