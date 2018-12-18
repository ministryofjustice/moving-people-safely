require 'feature_helper'

RSpec.feature 'Running automation report', type: :feature do
  let(:login_options) do
    {
      sso: {
        info: { permissions: [{ 'organisation' => User::ADMIN_ORGANISATION }] }
      }
    }
  end

  let(:nomis_alerts) do
    {
      "alerts":
      [
        {
          "alert_type":
            {
              "code": "X",
              "desc": "Security"
            },
          "alert_sub_type":
            {
              "code": "XEL",
              "desc": "Escape List"
            },
          "alert_date": 5.days.ago.to_date.to_s(:db),
          "status": "ACTIVE",
          "comment": "has a large poster on cell wall"
        },
        {
          "alert_type":
            {
              "code": "R",
              "desc": "Risk"
            },
          "alert_sub_type":
            {
              "code": "RKS",
              "desc": "Risk to Known Adult - Custody"
            },
          "alert_date": 5.days.ago.to_date.to_s(:db),
          "expiry_date": 20.days.from_now.to_date.to_s(:db),
          "status": "ACTIVE"
        },
        {
          "alert_type":
            {
              "code": "H",
              "desc": "Self harm"
            },
          "alert_sub_type":
            {
              "code": "HC",
              "desc": "Self Harm - Custody"
            },
          "alert_date": 2.days.ago.to_date.to_s(:db),
          "expiry_date": 20.days.from_now.to_date.to_s(:db),
          "status": "ACTIVE"
        }
      ]
    }.to_json
  end

  let!(:escort) { create(:escort, :issued) }

  before do
    stub_nomis_api_request(:get, "/offenders/#{escort.prison_number}/alerts?include_inactive=true", body: nomis_alerts)
    stub_nomis_api_request(:get, "/offenders/#{escort.prison_number}/location", status: 404)
  end

  scenario 'find ePER and run automation report' do
    login(nil, login_options)
    dashboard.click_start_a_per
    search.search_prison_number(escort.prison_number)
    click_link escort.prison_number

    within '#risk' do
        click_link 'View'
    end

    click_link 'Automation report'

    expect(page).to have_content('NOMIS Alerts')
    expect(page).to have_content('User input')
    expect(page).to have_content('Automation logic')
    expect(page).to have_content('Differences')
  end
end