require 'feature_helper'

RSpec.feature 'filling in a PER', 'Detainee unknown on NOMIS', type: :feature do
  let(:offences_data) do
    {
      offences: [
        { name: 'Burglary', case_reference: 'Ref 3064' },
        { name: 'Attempted murder', case_reference: 'Ref 7291' }
      ]
    }
  end

  let(:valid_establishment_body) do
    { establishment: { code: establishment_nomis_id } }.to_json
  end
  
  let(:establishment_nomis_id) { 'BDI' }
  let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }

  let(:move_data) { build(:move, from_establishment: prison) }
  let(:detainee) { build(:detainee) }
  let(:healthcare_data) { build(:healthcare, :with_medications) }
  let(:risk_data) { build(:risk, :with_high_csra) }

  let(:prison) do
    create(:prison, name: 'HMP Bedford', sso_id: establishment_sso_id,
      nomis_id: establishment_nomis_id)
  end

  before do
    create(:magistrates_court, name: move_data.to)
  end

  context 'a general user and a healthcare user' do
    let(:login_options) do
      {
        sso: {
          info: {
            permissions: [
              {'organisation' => establishment_sso_id}
            ]
          }
        }
      }
    end
    
    let(:healthcare_login_options) do 
      {
        sso: {
          info: {
            permissions: [
              {'organisation' => establishment_sso_id, 'roles' => ['healthcare']}
            ]
          }
        }
      }
    end
    
    context 'for a detainee unknown to NOMIS' do
      before do
        stub_nomis_api_request(:get,
          "/offenders/#{detainee.prison_number}", status: 404)
        stub_nomis_api_request(:get,
          "/offenders/#{detainee.prison_number}/image", status: 404)
        stub_nomis_api_request(:get,
          "/offenders/#{detainee.prison_number}/location",
          body: valid_establishment_body)
        stub_nomis_api_request(:get,
          "/offenders/#{detainee.prison_number}/charges", status: 404)
      end
      
      scenario 'create a new escort' do
        login(nil, login_options)

        dashboard.search(detainee.prison_number)
        dashboard.create_new_escort.click

        detainee_details.complete_form(detainee)

        move_details.complete_form(move_data)

        escort_page.confirm_move_info(move_data)
        escort_page.confirm_detainee_details(detainee)
        escort_page.click_edit_risk

        risk.complete_forms(risk_data)
        risk_summary.confirm_risk_details(risk_data)
        risk_summary.confirm_and_save

        escort_page.click_edit_offences

        offences.complete_form(offences_data)

        escort_page.confirm_offence_details(offences_data)

        click_button 'Sign out'

        login(nil, healthcare_login_options)

        dashboard.search(detainee.prison_number)
        dashboard.click_view_escort

        escort_page.click_edit_healthcare

        healthcare.complete_forms(healthcare_data)
        healthcare_summary.confirm_and_save

        escort_page.confirm_offences_action_link('View')
        escort_page.confirm_risk_action_link('View')
      end
    end
  end
end
