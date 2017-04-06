require 'feature_helper'

RSpec.feature 'Summary pages', type: :feature do
  scenario 'Risk summary page' do
    login

    detainee = create(:detainee)
    move = create(:move, :active)
    escort = create(:escort, detainee: detainee, move: move)
    visit "escorts/#{escort.id}/risk/summary"

    risk_summary.confirm_risk_details(escort.risk)
  end
end
