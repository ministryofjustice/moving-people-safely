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
    login

    healthcare_data = build(:healthcare, :with_medications)
    risk_data = build(:risk, :with_high_csra)
    detainee = build(:detainee)
    move_data = build(:move)

    stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}", status: 404)
    stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/image", status: 404)

    dashboard.search(detainee.prison_number)
    dashboard.create_new_escort.click

    detainee_details.complete_form(detainee)
    destinations = [
      { establishment: 'Hospital', must: :return },
      { establishment: 'Court', must: :return },
      { establishment: 'Dentist', must: :not_return },
      { establishment: 'Tribunal', must: :not_return }
    ]
    move_details.complete_form(move_data, destinations: destinations)

    escort_page.confirm_move_info(move_data, destinations: destinations)
    escort_page.confirm_detainee_details(detainee)
    escort_page.click_edit_healthcare

    healthcare.complete_forms(healthcare_data)
    healthcare_summary.confirm_and_save

    escort_page.confirm_healthcare_details(healthcare_data)
    escort_page.click_edit_risk

    risk.complete_forms(risk_data)
    risk_summary.confirm_risk_details(risk_data)
    risk_summary.confirm_and_save

    escort_page.confirm_risk_details(risk_data)
    stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/charges", status: 404)
    escort_page.click_edit_offences

    offences.complete_form(offences_data)
    escort_page.confirm_offence_details(offences_data)
  end
end
