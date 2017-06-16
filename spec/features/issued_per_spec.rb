require 'feature_helper'

RSpec.feature 'issued PERs', type: :feature do
  scenario 'Checking issued PER sections are read only and allows reprint' do
    login

    escort = create(:escort, :issued)

    visit escort_path(escort)

    escort_page.confirm_read_only_detainee_details
    escort_page.confirm_read_only_move_details

    escort_page.confirm_healthcare_status('Complete')
    escort_page.confirm_healthcare_action_link('View')
    escort_page.click_edit_healthcare('View')
    healthcare_summary.confirm_read_only
    healthcare_summary.click_back_to_per_page

    escort_page.confirm_risk_status('Complete')
    escort_page.confirm_risk_action_link('View')
    escort_page.click_edit_risk('View')
    risk_summary.confirm_read_only
    risk_summary.click_back_to_per_page

    escort_page.confirm_offences_status('Complete')
    escort_page.confirm_offences_action_link('View')
    escort_page.click_edit_offences('View')
    offences.confirm_read_only

    visit escort_path(escort)
    escort_page.click_reprint
  end
end
