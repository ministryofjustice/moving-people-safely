require 'feature_helper'

RSpec.feature 'PER show page', type: :feature do
  let(:prison_number) { 'A4534DF' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:move) { create(:move) }
  let(:default_escort_options) { { prison_number: prison_number, detainee: detainee, move: move } }
  let(:escort) { create(:escort, default_escort_options) }

  context 'alerts section' do
    before do
      login
      visit escort_path(escort)
    end

    context 'Not for release alert' do
      context 'when the unissued PER has move details' do
        let(:options) { {} }
        let(:move) { create(:move, options) }

        context 'when move has not for release set to no' do
          let(:options) { { not_for_release: 'no' } }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:not_for_release)
          end
        end

        context 'when move has not for release set to yes' do
          let(:options) { { not_for_release: 'yes', not_for_release_reason: 'held_for_immigration' } }

          scenario 'associated alert is displayed as active with associated reason displayed' do
            escort_page.confirm_alert_as_active(:not_for_release)
          end
        end
      end
    end

    context 'ACCT alert' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is not displayed' do
          escort_page.confirm_alert_not_present(:acct_status)
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has ACCT status as open' do
          let(:risk) { Risk.new(acct_status: 'open') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:acct_status)
          end
        end

        context 'when detainee has ACCT status as post closure' do
          let(:risk) { Risk.new(acct_status: 'post_closure') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:acct_status)
          end
        end

        context 'when detainee has ACCT status as closed in last 6 months' do
          let(:date) { Date.yesterday }
          let(:risk) { Risk.new(acct_status: 'closed', date_of_most_recently_closed_acct: date) }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:acct_status)
          end
        end

        context 'when detainee has ACCT status as none' do
          let(:risk) { Risk.new(acct_status: 'none') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:acct_status)
          end
        end

        context 'when detainee has ACCT status as some other value' do
          let(:risk) { Risk.new(acct_status: 'some-other-value') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:acct_status)
          end
        end
      end
    end

    context 'Rule 45' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is not displayed' do
          escort_page.confirm_alert_not_present(:rule_45)
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has Rule 45 as yes' do
          let(:risk) { Risk.new(rule_45: 'yes') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:rule_45)
          end
        end

        context 'when detainee has Rule 45 as no' do
          let(:risk) { Risk.new(rule_45: 'no') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:rule_45)
          end
        end
      end
    end

    context 'Escape risk' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is not displayed' do
          escort_page.confirm_alert_not_present(:current_e_risk)
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has E list as yes' do
          let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_standard') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:current_e_risk)
          end
        end

        context 'when detainee has escape risk as yes' do
          let(:risk) { Risk.new(previous_escape_attempts: 'yes', previous_escape_attempts_details: 'escape risk details') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:current_e_risk)
          end
        end

        context 'when detainee has E list as no' do
          let(:risk) { Risk.new(current_e_risk: 'no') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:current_e_risk)
          end
        end

        context 'when detainee has escape risk as no' do
          let(:risk) { Risk.new(previous_escape_attempts: 'no') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:current_e_risk)
          end
        end
      end
    end

    context 'CSRA' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is not displayed' do
          escort_page.confirm_alert_not_present(:csra)
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has CSRA as high' do
          let(:risk) { Risk.new(csra: 'high') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:csra)
          end
        end

        context 'when detainee has CSRA as standard' do
          let(:risk) { Risk.new(csra: 'standard') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:csra)
          end
        end
      end
    end
  end

  context 'move information' do
    context 'issued PER' do
      let(:escort) { create(:escort, :issued) }

      scenario 'displays all the mandatory move information' do
        login

        visit escort_path(escort)
        escort_page.confirm_move_info(escort.move)
      end
    end

    context 'unissued PER' do
      let(:escort) { create(:escort, :completed) }

      scenario 'displays all the mandatory move information' do
        login

        visit escort_path(escort)
        escort_page.confirm_move_info(escort.move)
      end
    end
  end

  context 'offences section' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/charges", status: 404)
    end

    let(:prison_number) { 'A3243AW' }
    let(:detainee) { create(:detainee, prison_number: prison_number) }
    let(:move) { create(:move) }
    let(:escort) { create(:escort, :with_no_offences, prison_number: prison_number, detainee: detainee, move: move) }

    let(:offences_data) {
      [
        { name: 'Burglary', case_reference: 'Ref 3064' },
        { name: 'Attempted murder', case_reference: 'Ref 7291' }
      ]
    }
    let(:offences_params) {
      {
        offences: offences_data
      }
    }

    scenario 'current offences are displayed' do
      login

      visit escort_path(escort)
      escort_page.click_edit_offences
      offences.complete_form(offences_params)
      escort_page.confirm_offences(offences_data)
    end
  end

  context 'cancelled PER' do
    scenario 'Checking cancelled PER sections are read only' do
      login

      escort = create(:escort, :cancelled)

      visit escort_path(escort)

      escort_page.confirm_read_only_detainee_details
      escort_page.confirm_read_only_move_details

      escort_page.confirm_healthcare_status('Complete')
      escort_page.confirm_healthcare_action_link('View')
      escort_page.click_edit_healthcare('View')
      healthcare_summary.confirm_read_only
      healthcare_summary.click_back_to_per_page

      escort_page.confirm_risk_status('Complete')
      escort_page.confirm_risk_action_link('View')
      escort_page.click_edit_risk('View')
      risk_summary.confirm_read_only
      risk_summary.click_back_to_per_page

      escort_page.confirm_offences_status('Complete')
      escort_page.confirm_offences_action_link('View')
      escort_page.click_edit_offences('View')
      offences.confirm_read_only
    end
  end

  context 'issued PER' do
    scenario 'Checking issued PER sections are read only and allows reprint' do
      login

      escort = create(:escort, :issued)

      visit escort_path(escort)

      escort_page.confirm_read_only_detainee_details
      escort_page.confirm_read_only_move_details

      escort_page.confirm_healthcare_status('Complete')
      escort_page.confirm_healthcare_action_link('View')
      escort_page.click_edit_healthcare('View')
      healthcare_summary.confirm_read_only
      healthcare_summary.click_back_to_per_page

      escort_page.confirm_risk_status('Complete')
      escort_page.confirm_risk_action_link('View')
      escort_page.click_edit_risk('View')
      risk_summary.confirm_read_only
      risk_summary.click_back_to_per_page

      escort_page.confirm_offences_status('Complete')
      escort_page.confirm_offences_action_link('View')
      escort_page.click_edit_offences('View')
      offences.confirm_read_only

      visit escort_path(escort)
      escort_page.click_reprint
    end
  end

  context 'expired PER' do
    scenario 'PER expired' do
      login

      escort = create(:escort, :expired)

      visit escort_path(escort)

      escort_page.confirm_not_cancellable
    end
  end
end
