require 'feature_helper'

RSpec.describe 'Summary pages', type: :system, js: true do
  scenario 'Risk summary page' do
    login

    detainee = create(:detainee)
    move = create(:move)
    risk = create(:risk)
    healthcare = create(:healthcare)
    escort = create(:escort, detainee: detainee, move: move, risk: risk, healthcare: healthcare)
    visit "escorts/#{escort.id}/risk"

    risk_summary.confirm_risk_details(escort.risk)
  end
end
