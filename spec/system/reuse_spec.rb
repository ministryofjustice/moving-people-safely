require 'feature_helper'

RSpec.describe 'Reuse of previously entered PER data', type: :system, js: true do
  context 'an issued PER that will be be reused' do
    let(:valid_json) { File.read(fixture_json_file_path) }
    let(:prison_number) { 'A4321FD' }
    let(:establishment_nomis_id) { 'BDI' }
    let(:bedford_sso_id) { 'bedford.prisons.noms.moj' }
    let(:bedford_nomis_id) { 'BDI' }
    let(:detainee) { create(:detainee, prison_number: prison_number, gender: 'male') }

    let(:move) { create(:move, :with_special_vehicle_details) }

    let(:fixture_json_file_path) do
      Rails.root.join('spec', 'support', 'fixtures', 'valid-nomis-charges.json')
    end

    let(:login_options) do
      { sso: { info: { permissions: [{'organisation' => bedford_sso_id}]}} }
    end

    let(:healthcare_login_options) do
      { sso: { info: { permissions: [{'organisation' => bedford_sso_id,
        'roles' => ['healthcare']}]}} }
    end

    let(:valid_body) do
      { establishment: { code: establishment_nomis_id } }.to_json
    end

    let!(:bedford) do
      create(:prison, name: 'HMP Bedford', sso_id: bedford_sso_id,
        nomis_id: bedford_nomis_id)
    end

    let(:move_data) do
      build(:move, date: 1.day.from_now,
        to: 'Bobbins Secure Youth Estate', to_type: 'youth_secure_estate')
    end

    let!(:reused_escort) do
      create(:escort, :issued, prison_number: prison_number, detainee: detainee,
        move: move)
    end

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/location",
        body: valid_body)
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
      stub_nomis_api_request(:get, "/offenders/#{prison_number}")
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/charges",
        body: valid_json)
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts")

      create(:youth_secure_estate, name: move_data.to)
    end

    scenario 'reviewing the data and reusing' do
      login(nil, login_options)

      dashboard.click_start_a_per

      search.search_prison_number(detainee.prison_number)
      search.click_start_new_per

      detainee_details.complete_form(detainee)

      move_details.confirm_special_vehicle_values(reused_escort.move)
      move_details.complete_form(move_data, gender: detainee.gender)

      escort_page.confirm_risk_status('Review')
      escort_page.click_edit_risk
      risk_summary.confirm_status('Review')
      risk_summary.confirm_review_warning
      risk_summary.confirm_and_save
      escort_page.confirm_risk_status('Complete')

      escort_page.confirm_offences_status('Review')
      escort_page.click_edit_offences
      offences.confirm_status('Review')
      offences.save_and_continue
      escort_page.confirm_offences_status('Complete')

      click_button 'Sign out'

      login(nil, healthcare_login_options)

      dashboard.click_start_a_per

      search.search_prison_number(detainee.prison_number)
      search.click_continue_per

      escort_page.confirm_healthcare_status('Review')
      escort_page.click_edit_healthcare
      healthcare_summary.confirm_status('Review')
      healthcare_summary.confirm_review_warning
      healthcare_summary.confirm_and_save
      escort_page.confirm_healthcare_status('Complete')
      escort_page.click_print
    end
  end

  context 'a completed document' do
    let(:prison_number) { 'A4321FD' }
    let(:detainee) { create(:detainee, prison_number: prison_number, gender: 'male') }

    before do
      create(:escort, :completed, prison_number: prison_number, detainee: detainee)
    end

    scenario 'editing the document' do
      login
      dashboard.click_start_a_per

      search.search_prison_number(detainee.prison_number)
      search.click_continue_per

      escort_page.confirm_healthcare_status('Complete')
      escort_page.click_edit_healthcare

      find("a", :text => /\AChange\z/, match: :first).click
      choose 'Yes', visible: false
      fill_in 'physical[physical_issues_details]', with: 'Some details'
      click_button 'Save and view summary'
      healthcare_summary.confirm_and_save
      escort_page.confirm_healthcare_status('Complete')
    end
  end
end
