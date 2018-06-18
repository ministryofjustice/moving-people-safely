require 'feature_helper'

RSpec.feature 'Reuse of previously entered PER data', type: :feature do
  scenario 'Reviewing the data of a reused PER' do
    fixture_json_file_path = Rails.root.join('spec', 'support', 'fixtures', 'valid-nomis-charges.json')
    valid_json = File.read(fixture_json_file_path)
    prison_number = 'A4321FD'
    establishment_nomis_id = 'BDI'
    valid_body = { establishment: { code: establishment_nomis_id } }.to_json
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/location", body: valid_body)
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
    stub_nomis_api_request(:get, "/offenders/#{prison_number}")
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/charges", body: valid_json)
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts")

    bedford_sso_id = 'bedford.prisons.noms.moj'
    bedford_nomis_id = 'BDI'
    bedford = create(:prison, name: 'HMP Bedford', sso_id: bedford_sso_id, nomis_id: bedford_nomis_id)

    move_data = build(:move, date: 1.day.from_now,
      to: 'Bobbins Secure Youth Estate', to_type: 'youth_secure_estate')
    create(:youth_secure_estate, name: move_data.to)

    login_options = { sso: { info: { permissions: [{'organisation' => bedford_sso_id}]}} }

    login(nil, login_options)

    detainee = create(:detainee, prison_number: prison_number)
    create(:escort, :issued, prison_number: prison_number, detainee: detainee)

    dashboard.click_start_a_per

    search.search_prison_number(detainee.prison_number)
    search.click_start_new_per

    detainee_details.complete_form(detainee)

    move_details.complete_form(move_data)

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

    login_options = { sso: { info: { permissions: [{'organisation' => bedford_sso_id, 'roles' => ['healthcare']}]}} }
    login(nil, login_options)

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

  scenario 'Editing a completed document' do
    login
    prison_number = 'A4321FD'
    detainee = create(:detainee, prison_number: prison_number)
    create(:escort, :completed, prison_number: prison_number, detainee: detainee)

    dashboard.click_start_a_per

    search.search_prison_number(detainee.prison_number)
    search.click_continue_per

    escort_page.confirm_healthcare_status('Complete')
    escort_page.click_edit_healthcare

    find("a", :text => /\AChange\z/, match: :first).click
    choose 'Yes'
    fill_in 'physical[physical_issues_details]', with: 'Some details'
    click_button 'Save and view summary'
    healthcare_summary.confirm_and_save
    escort_page.confirm_healthcare_status('Complete')
  end
end
