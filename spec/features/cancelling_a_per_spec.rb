require 'feature_helper'

RSpec.feature 'cancelling a PER', type: :feature do
  scenario 'Cancelling a non issued PER' do
    escort = create(:escort, :completed)

    login

    dashboard.assert_escorts_due(1)
    dashboard.assert_total_detainees_due_to_move_gauge(1)

    visit escort_path(escort)

    escort_page.click_cancel

    fill_in 'escort[cancelling_reason]', with: 'Started by mistake'
    click_button 'Cancel this PER'

    dashboard.assert_escorts_due(1)
    dashboard.assert_total_detainees_due_to_move_gauge(0)
  end
end
