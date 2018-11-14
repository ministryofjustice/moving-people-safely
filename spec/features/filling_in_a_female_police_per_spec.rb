require 'feature_helper'

RSpec.feature 'filling in a PER from a police station', type: :feature do
  let(:offences_data) do
    {
      offences: [
        { name: 'Burglary', case_reference: 'Ref 3064' },
        { name: 'Attempted murder', case_reference: 'Ref 7291' }
      ]
    }
  end

  let!(:banbury_police_station) do
    create(:police_custody, name: 'Banbury Police Station')
  end

  let(:login_options) do
    {
      sso: {
        info: {
          permissions: [{ 'organisation' => User::POLICE_ORGANISATION }]
        }
      }
    }
  end

  let(:move_data) { build(:move, from_establishment: banbury_police_station) }
  let(:escort) { build(:escort, move: move_data) }
  let(:healthcare_data) { build(:healthcare, :with_medications, escort: escort,
                                pregnant: 'yes', pregnant_details: '5 months') }
  let(:risk_data) { build(:risk, :from_police, :with_high_observation_level, escort: escort) }
  let(:detainee) { build(:detainee, gender: 'female') }

  before { create(:magistrates_court, name: move_data.to) }

  scenario 'adding a new escort, filling it in and approve it' do
    login(nil, login_options)

    expect(current_path).to eq select_police_station_path

    select_police_station.select_station('')
    select_police_station.expect_error_message
    select_police_station.select_station('Banbury Police Station')

    expect(current_path).to eq root_path

    dashboard.click_start_a_per

    search.search_pnc_number(detainee.pnc_number)
    search.click_start_new_per

    detainee_details.complete_form(detainee, location: :police)

    move_details.complete_form(move_data, location: :police, gender: :female)

    escort_page.confirm_move_info(move_data)
    escort_page.confirm_detainee_details(detainee, location: :police)
    escort_page.click_edit_risk

    risk.complete_forms(risk_data)
    risk_summary.confirm_risk_details(risk_data)
    risk_summary.confirm_and_save

    escort_page.click_edit_healthcare

    healthcare.complete_forms(healthcare_data)
    healthcare_summary.confirm_healthcare_details(healthcare_data)
    healthcare_summary.confirm_and_save
    escort_page.confirm_healthcare_labels(:police)

    escort_page.click_edit_offences

    offences.complete_form(offences_data)

    escort_page.confirm_offence_details(offences_data)
    escort_page.confirm_alert_as_active(:pregnant)

    escort = Escort.first
    visit(root_path)
    dashboard.confirm_awaiting_approval(escort.id_number)

    click_button 'Sign out'

    login_options = { sso: { info: { permissions: [{'organisation' => User::POLICE_ORGANISATION, 'roles' => ['sergeant']}]}} }
    login(nil, login_options)

    expect(current_path).to eq select_police_station_path

    select_police_station.select_station('Banbury Police Station')

    expect(current_path).to eq root_path

    dashboard.approve(escort.id_number)

    escort_page.click_approve

    confirm_approve.approve
  end
end
