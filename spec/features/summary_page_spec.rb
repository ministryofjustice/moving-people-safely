require 'feature_helper'

RSpec.feature 'Summary pages', type: :feature do
  scenario 'Risk summary page' do
    login

    detainee = create(:detainee, :with_active_move)
    visit "/#{detainee.id}/risk/summary"

    risk_summary.confirm_risk_details(detainee.risk)
  end
end
