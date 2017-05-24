require 'feature_helper'

RSpec.feature 'detainees due to move', type: :feature do

  context 'when there are no detainees due to move for the date provided' do
    scenario 'show no escorts and only the gauge for detainees' do
      login
      dashboard.search_escorts_due_on('11/08/2016')
      dashboard.assert_no_escorts_due_gauges
      dashboard.assert_no_escorts_due
    end
  end

  context 'when there are detainees due to move for the date provided' do
    scenario 'show associated escorts and incomplete gauges for all the PER components' do
      move = create(:move, date: '11/08/2016')
      create(:escort, :with_detainee, :with_complete_healthcare_assessment, move: move)

      move = create(:move, date: '11/08/2016')
      create(:escort, :with_detainee, :with_complete_risk_assessment, :with_complete_healthcare_assessment, move: move)

      move = create(:move,  date: '11/08/2016')
      create(:escort, :with_detainee, :with_complete_healthcare_assessment, :with_complete_offences, move: move)

      move = create(:move, date: '11/08/2016')
      create(:escort, :with_detainee, :with_complete_offences, :with_complete_healthcare_assessment, move: move)

      move = create(:move, date: '11/08/2016')
      create(:escort, :with_detainee, :completed, move: move)

      login
      dashboard.search_escorts_due_on('11/08/2016')
      dashboard.assert_total_detainees_due_to_move_gauge(5)
      dashboard.assert_incomplete_gauge(:risk, 3)
      dashboard.assert_complete_gauge(:healthcare)
      dashboard.assert_incomplete_gauge(:offences, 2)
      dashboard.assert_escorts_due(5)
    end
  end
end
