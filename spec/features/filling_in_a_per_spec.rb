require 'feature_helper'

RSpec.feature 'filling in a PER', type: :feature do
  let(:offences_data) {
    {
      offences: [
        { name: 'Burglary', case_reference: 'Ref 3064' },
        { name: 'Attempted murder', case_reference: 'Ref 7291' }
      ]
    }
  }

  scenario 'adding a new escort and filling it in' do
    establishment_sso_id = 'bedford.prisons.noms.moj'
    establishment_nomis_id = 'BDI'
    prison = create(:prison, name: 'HMP Bedford', sso_id: establishment_sso_id, nomis_id: establishment_nomis_id)
    login_options = { sso: { info: { permissions: [{'organisation' => establishment_sso_id}]}} }

    login(nil, login_options)

    healthcare_data = build(:healthcare, :with_medications)
    risk_data = build(:risk, :with_high_csra)
    escort = build(:escort, from_establishment: prison)
    create(:magistrates_court, name: escort.to)

    stub_nomis_api_request(:get, "/offenders/#{escort.prison_number}", status: 404)
    stub_nomis_api_request(:get, "/offenders/#{escort.prison_number}/image", status: 404)
    stub_nomis_api_request(:get, "/offenders/#{escort.prison_number}/charges", status: 404)
    valid_body = { establishment: { code: establishment_nomis_id } }.to_json
    stub_nomis_api_request(:get, "/offenders/#{escort.prison_number}/location", body: valid_body)

    dashboard.search(escort.prison_number)
    dashboard.create_new_escort.click

    detainee_details.complete_form(escort)

    move_details.complete_form(escort)

    escort_page.confirm_move_info(escort)
    escort_page.confirm_detainee_details(escort)
    escort_page.click_edit_risk

    risk.complete_forms(risk_data)
    risk_summary.confirm_risk_details(risk_data)
    risk_summary.confirm_and_save

    escort_page.click_edit_offences

    offences.complete_form(offences_data)

    escort_page.confirm_offence_details(offences_data)

    click_button 'Sign out'

    login_options = { sso: { info: { permissions: [{'organisation' => establishment_sso_id, 'roles' => ['healthcare']}]}} }
    login(nil, login_options)

    dashboard.search(escort.prison_number)
    dashboard.click_view_escort

    escort_page.click_edit_healthcare

    healthcare.complete_forms(healthcare_data)
    healthcare_summary.confirm_and_save

    escort_page.confirm_offences_action_link('View')
    escort_page.confirm_risk_action_link('View')
  end
end
