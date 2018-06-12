require 'feature_helper'

RSpec.feature 'police dashboard', type: :feature do
  scenario 'login as police user' do
    banbury_police_station = create(:police_custody, name: 'Banbury Police Station')
    cardigan_police_station = create(:police_custody, name: 'Cardigan Police Station')
    croydon_custody_unit = create(:police_custody, name: 'Croydon Custody Unit')

    escort_1 = create(:escort, :issued, :completed, date: Date.today, from_establishment: banbury_police_station, forenames: 'FRANKIE', surname: 'LEE', pnc_number: '67/123720F')
    escort_2 = create(:escort, :issued, :completed, date: Date.today, from_establishment: cardigan_police_station, forenames: 'JUDAS', surname: 'PRIEST', pnc_number: '23/723293D')
    escort_3 = create(:escort, :completed, date: Date.tomorrow, from_establishment: banbury_police_station, forenames: 'JOHN WESLEY', surname: 'HARDING', pnc_number: '11/231581J')

    login_options = { sso: { info: { permissions: [{'organisation' => User::POLICE_ORGANISATION}]}} }
    login(nil, login_options)

    expect(current_path).to eq select_police_station_path

    select 'Banbury Police Station', from: 'police_custody'
    click_button 'Save and continue'

    expect(current_path).to eq root_path
    expect(page.all('.move-row').size).to eq 1
    expect(page).to have_content 'LEE FRANKIE'
    expect(page).to have_content '67/123720F'

    expect(page).to_not have_content 'PRIEST JUDAS'
    expect(page).to_not have_content '23/723293D'
  end
end
