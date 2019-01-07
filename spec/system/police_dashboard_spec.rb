require 'feature_helper'

RSpec.describe 'police dashboard', type: :system, js: true do
  scenario 'login as police user' do
    banbury_police_station = create(:police_custody, name: 'Banbury Police Station')
    cardigan_police_station = create(:police_custody, name: 'Cardigan Police Station')
    croydon_custody_unit = create(:police_custody, name: 'Croydon Custody Unit')

    escort_1 = create(:escort, :issued, pnc_number: '67/123720F')
    escort_1.move.update(date: Date.today, from_establishment: banbury_police_station)
    escort_1.detainee.update(forenames: 'FRANKIE', surname: 'LEE')

    escort_2 = create(:escort, :issued, pnc_number: '23/723293D')
    escort_2.move.update(date: Date.today, from_establishment: cardigan_police_station)
    escort_2.detainee.update(forenames: 'JUDAS', surname: 'PRIEST')

    escort_3 = create(:escort, :completed, pnc_number: '11/231581J')
    escort_3.move.update(date: Date.tomorrow, from_establishment: banbury_police_station)
    escort_3.detainee.update(forenames: 'JOHN WESLEY', surname: 'HARDING')

    login_options = { sso: { info: { permissions: [{'organisation' => User::POLICE_ORGANISATION}]}} }
    login(nil, login_options)

    expect(current_path).to eq select_police_station_path
    fill_in 'police_station_selector_police_custody_id', with: "Banbury Police Station\n"
    click_button 'Save and continue'

    expect(current_path).to eq root_path
    expect(page.all('.move-row').size).to eq 1
    expect(page).to have_content 'LEE FRANKIE'
    expect(page).to have_content '67/123720F'

    expect(page).to_not have_content 'PRIEST JUDAS'
    expect(page).to_not have_content '23/723293D'
  end
end
