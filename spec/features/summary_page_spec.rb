require 'feature_helper'

RSpec.feature 'Summary pages', type: :feature do
  scenario 'Risk summary page' do
    login

    risk = create(:risk)
    healthcare = create(:healthcare)
    escort = create(:escort, risk: risk, healthcare: healthcare)
    visit "escorts/#{escort.id}/risk"

    risk_summary.confirm_risk_details(escort.risk)
  end
end
