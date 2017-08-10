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
            expect(page.find('#not_for_release_alert .alert-text').text).to be_empty
          end
        end

        context 'when move has not for release set to yes' do
          let(:options) { { not_for_release: 'yes', not_for_release_reason: 'held_for_immigration' } }

          scenario 'associated alert is displayed as active with associated reason displayed' do
            escort_page.confirm_alert_as_active(:not_for_release)
            within('#not_for_release_alert .alert-text') do
              expect(page).to have_content('Held for immigration')
            end
          end

          context 'and there is some details for the reason not for release' do
            let(:options) {
              {
                not_for_release: 'yes',
                not_for_release_reason: 'other',
                not_for_release_reason_details: 'some details'
              }
            }

            scenario 'associated alert is displayed as active with associated reason details displayed' do
              escort_page.confirm_alert_as_active(:not_for_release)
              within('#not_for_release_alert .alert-text') do
                expect(page).to have_content('Other (some details)')
              end
            end
          end
        end
      end
    end

    context 'ACCT alert' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:acct_status)
          expect(page.find('#acct_status_alert .alert-text').text).to be_empty
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has ACCT status as open' do
          let(:risk) { Risk.new(acct_status: 'open') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:acct_status)
            within('#acct_status_alert .alert-text') do
              expect(page).to have_content('Open')
            end
          end
        end

        context 'when detainee has ACCT status as post closure' do
          let(:risk) { Risk.new(acct_status: 'post_closure') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:acct_status)
            within('#acct_status_alert .alert-text') do
              expect(page).to have_content('Post closure')
            end
          end
        end

        context 'when detainee has ACCT status as closed in last 6 months' do
          let(:date) { Date.yesterday }
          let(:risk) { Risk.new(acct_status: 'closed_in_last_6_months', date_of_most_recently_closed_acct: date) }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:acct_status)
            within('#acct_status_alert .alert-text') do
              expect(page).to have_content("Closed: #{date}")
            end
          end
        end

        context 'when detainee has ACCT status as none' do
          let(:risk) { Risk.new(acct_status: 'none') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:acct_status)
            expect(page.find('#acct_status_alert .alert-text').text).to be_empty
          end
        end

        context 'when detainee has ACCT status as some other value' do
          let(:risk) { Risk.new(acct_status: 'some-other-value') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:acct_status)
            expect(page.find('#acct_status_alert .alert-text').text).to match(/^some-other-value$/i)
          end
        end
      end
    end

    context 'Rule 45' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:rule_45)
          expect(page).not_to have_selector('#rule_45_alert .alert-text')
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has Rule 45 as yes' do
          let(:risk) { Risk.new(rule_45: 'yes') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:rule_45)
            expect(page).not_to have_selector('#rule_45_alert .alert-text')
          end
        end

        context 'when detainee has Rule 45 as no' do
          let(:risk) { Risk.new(rule_45: 'no') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:rule_45)
            expect(page).not_to have_selector('#rule_45_alert .alert-text')
          end
        end
      end
    end

    context 'E list' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to be_empty
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has E list as yes and as standard' do
          let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_standard') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:e_list)
            expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Standard')
          end
        end

        context 'when detainee has E list as yes and as escort' do
          let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_escort') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:e_list)
            expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Escort')
          end
        end

        context 'when detainee has E list as yes and as heightened' do
          let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_heightened') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:e_list)
            expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Heightened')
          end
        end

        context 'when detainee has E list as no' do
          let(:risk) { Risk.new(current_e_risk: 'no') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:e_list)
            expect(page.find('#e_list_alert .alert-text').text).to be_empty
          end
        end
      end
    end

    context 'CSRA' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:csra)
          expect(page).not_to have_selector('#csra_alert .alert-text')
          expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^Standard$/i)
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has CSRA as high' do
          let(:risk) { Risk.new(csra: 'high') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:csra)
            expect(page).not_to have_selector('#csra_alert .alert-text')
            expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^high$/i)
          end
        end

        context 'when detainee has CSRA as standard' do
          let(:risk) { Risk.new(csra: 'standard') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:csra)
            expect(page).not_to have_selector('#csra_alert .alert-text')
            expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^Standard$/i)
          end
        end
      end
    end

    context 'Category A' do
      context 'when PER has no yet a risk assessment' do
        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:category_a)
          expect(page).not_to have_selector('#category_a_alert .alert-text')
        end
      end

      context 'when PER has a risk assessment' do
        let(:escort) { create(:escort, default_escort_options.merge(risk: risk)) }

        context 'when detainee has Category A as yes' do
          let(:risk) { Risk.new(category_a: 'yes') }

          scenario 'associated alert is displayed as active' do
            escort_page.confirm_alert_as_active(:category_a)
            expect(page).not_to have_selector('#category_a_alert .alert-text')
          end
        end

        context 'when detainee has Category A as no' do
          let(:risk) { Risk.new(category_a: 'no') }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:category_a)
            expect(page).not_to have_selector('#category_a_alert .alert-text')
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
    let(:detainee) { create(:detainee, :with_no_offences, prison_number: prison_number) }
    let(:move) { create(:move) }
    let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }

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
end
