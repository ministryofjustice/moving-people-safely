require 'feature_helper'

RSpec.feature 'filling in a PER as a police user', type: :feature do
  let(:offences_data) {
    {
      offences: [
        { name: 'Burglary', case_reference: 'Ref 3064' },
        { name: 'Attempted murder', case_reference: 'Ref 7291' }
      ]
    }
  }

  scenario 'adding a new escort and filling it in' do
    establishment_sso_id = 'police.noms.moj'
    establishment_nomis_id = 'BRI'
    police_custody = create(:police_custody, name: 'Brighton', sso_id: establishment_sso_id, nomis_id: establishment_nomis_id)
    login_options = { sso: { info: { permissions: [{'organisation' => establishment_sso_id}]}} }

    login(nil, login_options)

    healthcare_data = build(:healthcare, :with_medications)
    risk_data = build(:risk, :with_high_csra)
    escort_data = build(:escort, :with_police_not_for_release_reason,
                      from_establishment: police_custody)
    create(:magistrates_court, name: escort_data.to)

    select_police_station.select_station('Brighton')

    dashboard.search_for_pnc_number(escort_data.pnc_number)
    dashboard.create_new_escort.click

    detainee_details.complete_form(escort_data)

    move_details.complete_form(escort_data)

    escort_page.confirm_move_info(escort_data)
    escort_page.confirm_detainee_details(escort_data)
    escort_page.click_edit_risk

    risk.complete_forms(risk_data)
    risk_summary.confirm_risk_details(risk_data)
    risk_summary.confirm_and_save

    escort_page.click_edit_offences

    offences.complete_form(offences_data)

    escort_page.confirm_offence_details(offences_data)

    click_button 'Sign out'
  end
end
