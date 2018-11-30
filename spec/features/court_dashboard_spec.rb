require 'feature_helper'

RSpec.feature 'court dashboard', type: :feature do
  scenario 'login as court user' do
    luton_court = create(:magistrates_court, name: 'Luton CC', nomis_id: 'luton')
    basildon_court = create(:magistrates_court, name: 'Basildon CC', nomis_id: 'basildon')
    st_albans_court = create(:crown_court, name: 'St Albans CC', nomis_id: 'albans')

    escort_1 = create(:escort, :issued, :completed, prison_number: 'A9876XC')
    escort_1.move.update(date: Date.today, to: luton_court.name)
    escort_1.detainee.update(forenames: 'PETER', surname: 'GABRIEL')

    escort_2 = create(:escort, :issued, :completed)
    escort_2.move.update(date: Date.today, to: basildon_court.name)

    escort_3 = create(:escort, :completed)
    escort_3.move.update(date: Date.tomorrow, to: luton_court.name)

    login_options = { sso: { info: { permissions: [{'organisation' => User::COURT_ORGANISATION}]}} }
    login(nil, login_options)

    expect(current_path).to eq select_court_path

    choose "Magistrates' court"
    select 'Luton CC', from: 'court_selector_magistrates_court_id'
    click_button 'Save and continue'

    expect(current_path).to eq court_path
    expect(page.all('tbody').size).to eq 1
    expect(page).to have_content 'GABRIELPETER'

    click_link 'A9876XC'
    expect(current_path).to eq escort_path(escort_1)

    click_link 'Create or view a PER'

    click_link 'Change court'
    choose "Crown court"
    select 'St Albans CC', from: 'court_selector_crown_court_id'

    expect(page.all('tbody').size).to eq 0
  end
end
