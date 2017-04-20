require 'feature_helper'

RSpec.feature 'PER show page', type: :feature do
  let(:prison_number) { 'A4534DF' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:move) { create(:move) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }

  context 'alerts section' do
    before do
      login
      visit escort_path(escort)
    end

    context 'Not for release alert' do
      context 'when the unissued PER has move details' do
        let(:options) { {} }
        let(:move) { create(:move, :active, options) }

        context 'when move has not for release set to unknown' do
          let(:options) { { not_for_release: 'unknown' } }

          scenario 'associated alert is displayed as inactive' do
            escort_page.confirm_alert_as_inactive(:not_for_release)
            expect(page.find('#not_for_release_alert .alert-text').text).to be_empty
          end
        end

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
      context 'when detainee has ACCT status as open' do
        let(:risk) { Risk.new(acct_status: 'open') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:acct_status)
          within('#acct_status_alert .alert-text') do
            expect(page).to have_content('Open')
          end
        end
      end

      context 'when detainee has ACCT status as post closure' do
        let(:risk) { Risk.new(acct_status: 'post_closure') }
        let(:detainee) { create(:detainee, risk: risk) }

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
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:acct_status)
          within('#acct_status_alert .alert-text') do
            expect(page).to have_content("Closed: #{date}")
          end
        end
      end

      context 'when detainee has ACCT status as none' do
        let(:risk) { Risk.new(acct_status: 'none') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:acct_status)
          expect(page.find('#acct_status_alert .alert-text').text).to be_empty
        end
      end

      context 'when detainee has ACCT status as unknown' do
        let(:risk) { Risk.new(acct_status: 'unknown') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:acct_status)
          expect(page.find('#acct_status_alert .alert-text').text).to be_empty
        end
      end

      context 'when detainee has ACCT status as some other value' do
        let(:risk) { Risk.new(acct_status: 'some-other-value') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:acct_status)
          expect(page.find('#acct_status_alert .alert-text').text).to match(/^some-other-value$/i)
        end
      end
    end

    context 'Rule 45' do
      context 'when detainee has Rule 45 as yes' do
        let(:risk) { Risk.new(rule_45: 'yes') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:rule_45)
          expect(page).not_to have_selector('#rule_45_alert .alert-text')
        end
      end

      context 'when detainee has Rule 45 as no' do
        let(:risk) { Risk.new(rule_45: 'no') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:rule_45)
          expect(page).not_to have_selector('#rule_45_alert .alert-text')
        end
      end

      context 'when detainee has Rule 45 as unknown' do
        let(:risk) { Risk.new(rule_45: 'unknown') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:rule_45)
          expect(page).not_to have_selector('#rule_45_alert .alert-text')
        end
      end
    end

    context 'E list' do
      context 'when detainee has E list as yes and as standard' do
        let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_standard') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Standard')
        end
      end

      context 'when detainee has E list as yes and as escort' do
        let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_escort') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Escort')
        end
      end

      context 'when detainee has E list as yes and as heightened' do
        let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_heightened') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Heightened')
        end
      end

      context 'when detainee has E list as no' do
        let(:risk) { Risk.new(current_e_risk: 'no') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to be_empty
        end
      end

      context 'when detainee has E list as unknown' do
        let(:risk) { Risk.new(current_e_risk: 'unknown') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to be_empty
        end
      end
    end

    context 'CSRA' do
      context 'when detainee has CSRA as high' do
        let(:risk) { Risk.new(csra: 'high') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:csra)
          expect(page).not_to have_selector('#csra_alert .alert-text')
          expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^high$/i)
        end
      end

      context 'when detainee has CSRA as standard' do
        let(:risk) { Risk.new(csra: 'standard') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:csra)
          expect(page).not_to have_selector('#csra_alert .alert-text')
          expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^Standard$/i)
        end
      end

      context 'when detainee has CSRA as unknown' do
        let(:risk) { Risk.new(csra: 'unknown') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:csra)
          expect(page).not_to have_selector('#csra_alert .alert-text')
          expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^Standard$/i)
        end
      end
    end

    context 'Category A' do
      context 'when detainee has Category A as yes' do
        let(:risk) { Risk.new(category_a: 'yes') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:category_a)
          expect(page).not_to have_selector('#category_a_alert .alert-text')
        end
      end

      context 'when detainee has Category A as no' do
        let(:risk) { Risk.new(category_a: 'no') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:category_a)
          expect(page).not_to have_selector('#category_a_alert .alert-text')
        end
      end

      context 'when detainee has Category A as unknown' do
        let(:risk) { Risk.new(category_a: 'unknown') }
        let(:detainee) { create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:category_a)
          expect(page).not_to have_selector('#category_a_alert .alert-text')
        end
      end
    end

    context 'MPV' do
      context 'when detainee has MPV as yes' do
        let(:healthcare) { Healthcare.new(mpv: 'yes') }
        let(:detainee) { create(:detainee, healthcare: healthcare) }

        scenario 'associated alert is displayed as active' do
          escort_page.confirm_alert_as_active(:mpv)
          expect(page).not_to have_selector('#mpv_alert .alert-text')
        end
      end

      context 'when detainee has MPV as no' do
        let(:healthcare) { Healthcare.new(mpv: 'no') }
        let(:detainee) { create(:detainee, healthcare: healthcare) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:mpv)
          expect(page).not_to have_selector('#mpv_alert .alert-text')
        end
      end

      context 'when detainee has MPV as unknown' do
        let(:healthcare) { Healthcare.new(mpv: 'unknown') }
        let(:detainee) { create(:detainee, healthcare: healthcare) }

        scenario 'associated alert is displayed as inactive' do
          escort_page.confirm_alert_as_inactive(:mpv)
          expect(page).not_to have_selector('#mpv_alert .alert-text')
        end
      end
    end
  end

  context 'move information' do
    let(:detainee) { create(:detainee) }
    let(:move) { create(:move) }
    let(:escort) { create(:escort, detainee: detainee, move: move) }

    context 'issued PER' do
      let(:move) { create(:move, :issued) }

      scenario 'displays all the mandatory move information' do
        login

        visit escort_path(escort)
        escort_page.confirm_move_info(move)
      end
    end

    context 'PER with an active move' do
      let(:move) { create(:move, :active) }

      scenario 'displays all the mandatory move information' do
        login

        visit escort_path(escort)
        escort_page.confirm_move_info(move)
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
