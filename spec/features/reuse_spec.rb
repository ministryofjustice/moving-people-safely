require 'feature_helper'

RSpec.feature 'Reuse of previously entered PER data', type: :feature do
  scenario 'Reviewing the data of a reused PER' do
    login

    prison_number = 'A4321FD'
    detainee = create(:detainee, prison_number: prison_number)
    create(:escort, :issued, prison_number: prison_number, detainee: detainee)

    dashboard.search(detainee.prison_number)
    dashboard.click_add_new_escort
    move_details.complete_date_field Date.tomorrow.strftime('%d/%m/%Y')

    escort_page.confirm_healthcare_status('Review')
    escort_page.click_edit_healthcare
    healthcare_summary.confirm_status('Review')
    healthcare_summary.confirm_and_save
    escort_page.confirm_healthcare_status('Complete')

    escort_page.confirm_risk_status('Review')
    escort_page.click_edit_risk
    risk_summary.confirm_status('Review')
    risk_summary.confirm_and_save
    escort_page.confirm_risk_status('Complete')

    escort_page.confirm_offences_status('Review')
    escort_page.click_edit_offences
    offences.confirm_status('Review')
    offences.save_and_continue
    escort_page.confirm_offences_status('Complete')

    escort_page.click_print
  end

  scenario 'Editing a completed document' do
    login
    prison_number = 'A4321FD'
    detainee = create(:detainee, prison_number: prison_number)
    create(:escort, :completed, prison_number: prison_number, detainee: detainee)

    dashboard.search(detainee.prison_number)
    dashboard.click_view_escort
    escort_page.confirm_healthcare_status('Complete')
    escort_page.click_edit_healthcare

    find("a", :text => /\AChange\z/, match: :first).click
    choose 'Clear selection'
    click_button 'Save and view summary'
    healthcare_summary.confirm_status 'Incomplete'
  end
end
