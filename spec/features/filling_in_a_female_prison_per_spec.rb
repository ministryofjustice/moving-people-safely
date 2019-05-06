require 'feature_helper'

RSpec.feature 'filling in a PER for a female from a prison', type: :feature do
  let(:establishment_sso_id) { 'bedford.prisons.noms.moj' }
  let(:establishment_nomis_id) { 'BDI' }
  let(:detainee) { build(:detainee, gender: 'female') }
  let(:move_data) { build(:move, :with_child, from_establishment: prison) }
  let(:escort) { build(:escort, move: move_data) }
  let(:risk_data) { build(:risk, :with_high_csra, escort: escort) }

  let(:offences_data) do
    {
      offences: [
        { name: 'Burglary', case_reference: 'Ref 3064' },
        { name: 'Attempted murder', case_reference: 'Ref 7291' }
      ]
    }
  end

  let(:prison) do
    create(:prison, name: 'HMP Bedford', sso_id: establishment_sso_id,
           nomis_id: establishment_nomis_id)
  end

  let(:login_options) do
    {
      sso: {
        info: { permissions: [{ 'organisation' => establishment_sso_id }] }
      }
    }
  end

  let(:valid_body) do
    { establishment: { code: establishment_nomis_id } }.to_json
  end

  let(:healthcare_data) do
    build(:healthcare, :with_medications, escort: escort, female_hygiene_kit: 'yes')
  end

  let(:healthcare_login_options) do
    {
      sso: {
        info: {
          permissions: [
            { 'organisation' => establishment_sso_id,
              'roles' => ['healthcare'] }
          ]
        }
      }
    }
  end

  before do
    stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/location", body: valid_body)
    create(:magistrates_court, name: move_data.to)
  end

  context 'NOMIS returns 404 for detainee details, image & charges' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}", status: 404)
      stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/image", status: 404)
      stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/charges", status: 404)
      stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/alerts", status: 404)
    end

    scenario 'adding a new escort and filling it in' do
      login(nil, login_options)

      dashboard.click_start_a_per

      search.search_prison_number(detainee.prison_number)
      search.click_start_new_per

      detainee_details.complete_form(detainee)

      move_details.complete_form(move_data, gender: :female)

      escort_page.confirm_move_info(move_data)
      escort_page.confirm_detainee_details(detainee)
      escort_page.click_edit_risk

      risk.complete_forms(risk_data)
      risk_summary.confirm_risk_details(risk_data)
      risk_summary.confirm_and_save

      escort_page.click_edit_offences

      offences.complete_form(offences_data)

      escort_page.confirm_offence_details(offences_data)
      escort_page.confirm_detainee_details(detainee)

      click_button 'Sign out'

      login(nil, healthcare_login_options)

      dashboard.click_start_a_per

      search.search_prison_number(detainee.prison_number)
      search.click_continue_per

      escort_page.click_edit_healthcare

      healthcare.complete_forms(healthcare_data, 'female')
      healthcare_summary.confirm_healthcare_details(healthcare_data)
      healthcare_summary.confirm_and_save

      escort_page.confirm_offences_action_link('View')
      escort_page.confirm_risk_action_link('View')
      escort_page.confirm_healthcare_labels(:prison)
    end
  end
end
