require 'feature_helper'

RSpec.feature 'detainees due to move', type: :feature do

  context 'when there are no detainees due to move for the date provided' do
    scenario 'show no moves and only the gauge for detainees' do
      login
      dashboard.search_moves_due_on('11/08/2016')
      dashboard.assert_no_moves_due_gauges
      dashboard.assert_no_moves_due
    end
  end

  context 'when there are detainees due to move for the date provided' do
    scenario 'show associated moves and incomplete gauges for all the PER components' do
      detainee = FactoryGirl.create(:detainee)
      detainee.moves << FactoryGirl.create(:move, :with_complete_healthcare_workflow, date: '11/08/2016')
      detainee = FactoryGirl.create(:detainee)
      detainee.moves << FactoryGirl.create(:move, :with_complete_risk_workflow, :with_complete_healthcare_workflow, date: '11/08/2016')
      detainee = FactoryGirl.create(:detainee)
      detainee.moves << FactoryGirl.create(:move, :with_complete_healthcare_workflow, :with_complete_offences_workflow,  date: '11/08/2016')
      detainee = FactoryGirl.create(:detainee)
      detainee.moves << FactoryGirl.create(:move, :with_complete_offences_workflow, :with_complete_healthcare_workflow,  date: '11/08/2016')
      detainee = FactoryGirl.create(:detainee)
      detainee.moves << FactoryGirl.create(:move, :confirmed, date: '11/08/2016')

      login
      dashboard.search_moves_due_on('11/08/2016')
      dashboard.assert_total_detainees_due_to_move_gauge(5)
      dashboard.assert_incomplete_gauge(:risk, 3)
      dashboard.assert_complete_gauge(:healthcare)
      dashboard.assert_incomplete_gauge(:offences, 2)
      dashboard.assert_moves_due(5)
    end
  end
end
