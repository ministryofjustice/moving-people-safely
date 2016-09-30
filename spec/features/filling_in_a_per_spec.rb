require 'feature_helper'

RSpec.feature 'filling in a PER', type: :feature do
  scenario 'adding a new escort and filling it in' do
    login

    prison_number_thats_not_in_db = build(:detainee).prison_number
    detainee = create(:detainee, :with_completed_considerations)
    move_data = build(:move)

    dashboard.search(prison_number_thats_not_in_db)
    dashboard.create_new_profile.click

    detainee.prison_number = prison_number_thats_not_in_db

    detainee_details.complete_form(detainee)
    move_details.complete_form(move_data)

    profile.confirm_move_info(move_data)
    profile.confirm_detainee_details(detainee)
    profile.click_edit_healthcare

    healthcare.complete_forms(detainee.healthcare)
    healthcare_summary.confirm_and_save

    profile.confirm_healthcare_details(detainee.healthcare)
    profile.click_edit_risk

    risk.complete_forms(detainee.risk)
    risk_summary.confirm_risk_details(detainee.risk)
    risk_summary.confirm_and_save

    profile.confirm_risk_details(detainee.risk)
    profile.click_edit_offences

    offences.complete_form
    profile.confirm_offences_details

    # FIXME 22/09/2016
    # profile.confirm_header_details(detainee)
  end
end
