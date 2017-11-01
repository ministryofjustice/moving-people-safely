require 'feature_helper'

RSpec.feature 'court dashboard', type: :feature do
  scenario 'login as court user' do
    luton_court = create(:magistrates_court, name: 'Luton CC', nomis_id: 'luton')
    basildon_court = create(:magistrates_court, name: 'Basildon CC', nomis_id: 'basildon')
    st_albans_court = create(:magistrates_court, name: 'St Albans CC', nomis_id: 'albans')

    escort = create(:escort, :issued, :completed)
    move = create(:move, escort: escort, date: Date.today, to: luton_court.name)
    detainee = create(:detainee, escort: escort, forenames: 'PETER', surname: 'GABRIEL')

    escort = create(:escort, :issued, :completed)
    move = create(:move, escort: escort, date: Date.today, to: basildon_court.name)

    escort = create(:escort, :completed)
    move = create(:move, escort: escort, date: Date.tomorrow, to: luton_court.name)

    login_options = { sso: { info: { permissions: [{'organisation' => User::COURT_ORGANISATION}]}} }
    login(nil, login_options)

    expect(current_path).to eq select_court_path

    select 'Luton CC', from: 'magistrates_court'
    click_button 'Save and continue'

    expect(current_path).to eq court_path
    expect(page.all('tbody').size).to eq 1
    expect(page).to have_content 'GABRIELPETER'

    click_link 'Change court'
    select 'St Albans CC', from: 'magistrates_court'

    expect(page.all('tbody').size).to eq 0
  end
end
