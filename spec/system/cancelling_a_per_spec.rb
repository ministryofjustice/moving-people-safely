require 'feature_helper'

RSpec.describe 'cancelling a PER', type: :system, js: true do
  scenario 'Cancelling a non issued PER' do
    luton_court = create(:magistrates_court, name: 'Luton CC', nomis_id: 'luton')
    escort = create(:escort, :issued, prison_number: 'A9876XC')
    escort.move.update(date: Date.today, to: luton_court.name)

    login

    dashboard.assert_escorts_due(1)
    dashboard.assert_total_detainees_due_to_move_gauge(1)

    visit escort_path(escort)

    escort_page.click_cancel

    fill_in 'escort[cancelling_reason]', with: 'Started by mistake'
    click_button 'Cancel this PER'

    dashboard.assert_escorts_due(1)
    dashboard.assert_total_detainees_due_to_move_gauge(0)

    escort.reload
    expect(page).to have_content("CancelledBy: #{escort.canceller.full_name}. #{escort.cancelling_reason}")

    click_button 'Sign out'

    login_options = { sso: { info: { permissions: [{'organisation' => User::COURT_ORGANISATION}]}} }
    login(nil, login_options)

    choose "Magistrates' court", visible: false
    fill_in 'court_selector_magistrates_court_id', with: "Luton CC\n"
    click_button 'Save and continue'

    expect(current_path).to eq court_path
    expect(page.all('tbody').size).to eq 1

    expect(page).to have_content("Cancelled by: #{escort.canceller.full_name}, at #{escort.cancelled_at.to_s(:timestamped)}. #{escort.cancelling_reason}.")
  end
end
