require 'feature_helper'

RSpec.describe 'detainees due to move', type: :system, js: true do
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

    scenario 'shows escorts scoped in the establishment of the user' do
      bedford_sso_id = 'bedford.prisons.noms.moj'
      bedford_nomis_id = 'BDI'
      bedford = create(:prison, name: 'HMP Bedford', sso_id: bedford_sso_id, nomis_id: bedford_nomis_id)

      brixton_sso_id = 'brixton.prisons.noms.moj'
      brixton_nomis_id = 'BXI'
      brixton = create(:prison, name: 'HMP Brixton', sso_id: brixton_sso_id, nomis_id: brixton_nomis_id)
      move_date = '12/10/2017'

      move = create(:move, date: move_date, from_establishment: bedford)
      create(:escort, :completed, move: move)

      move = create(:move, date: move_date, from_establishment: bedford)
      create(:escort, :completed, move: move)

      move = create(:move, date: move_date, from_establishment: brixton)
      create(:escort, :completed, move: move)

      login_options = { sso: { info: { permissions: [{'organisation' => bedford_sso_id}]}} }

      login(nil, login_options)

      dashboard.search_escorts_due_on(move_date)
      dashboard.assert_escorts_due(2)
    end
  end
end
