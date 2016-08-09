require 'feature_helper'

RSpec.feature 'Reuse of previously entered PER data', type: :feature do
  scenario 'Reviewing the data of a reused PER' do
    login

    detainee = create(:detainee, :with_completed_move)

    dashboard.search(detainee.prison_number)
    dashboard.click_add_new_move
    move_details.complete_date_field Date.tomorrow.strftime('%d/%m/%Y')

    # TODO: this can be better!
    #profile.confirm_header_details(detainee)
    #profile.confirm_detainee_details(detainee)
    #profile.confirm_move_details(detainee.active_move)

    profile.confirm_healthcare_status('Review')
    profile.click_edit_healthcare
    healthcare_summary.confirm_status('Review')
    healthcare_summary.confirm_and_save
    profile.confirm_healthcare_status('Complete')

    profile.confirm_risk_status('Review')
    profile.click_edit_risk
    risk_summary.confirm_status('Review')
    risk_summary.confirm_and_save
    profile.confirm_risk_status('Complete')

    profile.confirm_offences_status('Review')
    profile.click_edit_offences
    offences.confirm_status('Review')
    offences.save_and_continue
    profile.confirm_offences_status('Complete')

    profile.click_print
  end

  scenario 'Editing a completed document' do
    login
    detainee = create(:detainee)
    move = create(:move, :active, :confirmed)
    detainee.moves << move

    dashboard.search(detainee.prison_number)
    dashboard.click_view_profile
    profile.confirm_healthcare_status('Complete')
    profile.click_edit_healthcare

    find("a", :text => /\AChange\z/, match: :first).click
    choose 'Clear selection'
    click_button 'Save and view summary'
    healthcare_summary.confirm_status 'Incomplete'
  end
end
