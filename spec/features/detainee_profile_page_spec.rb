require 'feature_helper'

RSpec.feature 'detainee profile page', type: :feature do
  context 'alerts section' do
    before do
      login
      visit detainee_path(detainee)
    end

    context 'when detainee has no moves and no assessments' do
      let(:detainee) { FactoryGirl.create(:detainee, :without_assessments) }

      scenario 'all alerts are displayed an inactive' do
        profile.confirm_all_alerts_as_inactive
      end
    end

    context 'Not for release alert' do
      context 'when detainee has no active moves' do
        let(:detainee) { FactoryGirl.create(:detainee, :with_no_moves) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:not_for_release)
          expect(page.find('#not_for_release_alert .alert-text').text).to be_empty
        end
      end

      context 'when the detainee has an active move' do
        let(:options) { {} }
        let(:active_move) { FactoryGirl.create(:move, :active, options) }
        let(:detainee) { FactoryGirl.create(:detainee, moves: [active_move]) }

        context 'when active move has not for release set to unknown' do
          let(:options) { { not_for_release: 'unknown' } }

          scenario 'associated alert is displayed as inactive' do
            profile.confirm_alert_as_inactive(:not_for_release)
            expect(page.find('#not_for_release_alert .alert-text').text).to be_empty
          end
        end

        context 'when active move has not for release set to no' do
          let(:options) { { not_for_release: 'no' } }

          scenario 'associated alert is displayed as inactive' do
            profile.confirm_alert_as_inactive(:not_for_release)
            expect(page.find('#not_for_release_alert .alert-text').text).to be_empty
          end
        end

        context 'when active move has not for release set to yes' do
          let(:options) { { not_for_release: 'yes', not_for_release_reason: 'held_for_immigration' } }

          scenario 'associated alert is displayed as active with associated reason displayed' do
            profile.confirm_alert_as_active(:not_for_release)
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
              profile.confirm_alert_as_active(:not_for_release)
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
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:acct_status)
          within('#acct_status_alert .alert-text') do
            expect(page).to have_content('Open')
          end
        end
      end

      context 'when detainee has ACCT status as post closure' do
        let(:risk) { Risk.new(acct_status: 'post_closure') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:acct_status)
          within('#acct_status_alert .alert-text') do
            expect(page).to have_content('Post closure')
          end
        end
      end

      context 'when detainee has ACCT status as closed in last 6 months' do
        let(:date) { Date.yesterday }
        let(:risk) { Risk.new(acct_status: 'closed_in_last_6_months', date_of_most_recently_closed_acct: date) }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:acct_status)
          within('#acct_status_alert .alert-text') do
            expect(page).to have_content("Closed: #{date}")
          end
        end
      end

      context 'when detainee has ACCT status as none' do
        let(:risk) { Risk.new(acct_status: 'none') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:acct_status)
          expect(page.find('#acct_status_alert .alert-text').text).to be_empty
        end
      end

      context 'when detainee has ACCT status as unknown' do
        let(:risk) { Risk.new(acct_status: 'unknown') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:acct_status)
          expect(page.find('#acct_status_alert .alert-text').text).to be_empty
        end
      end

      context 'when detainee has ACCT status as some other value' do
        let(:risk) { Risk.new(acct_status: 'some-other-value') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:acct_status)
          expect(page.find('#acct_status_alert .alert-text').text).to match(/^some-other-value$/i)
        end
      end
    end

    context 'Rule 45' do
      context 'when detainee has Rule 45 as yes' do
        let(:risk) { Risk.new(rule_45: 'yes') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:rule_45)
          expect(page).not_to have_selector('#rule_45_alert .alert-text')
        end
      end

      context 'when detainee has Rule 45 as no' do
        let(:risk) { Risk.new(rule_45: 'no') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:rule_45)
          expect(page).not_to have_selector('#rule_45_alert .alert-text')
        end
      end

      context 'when detainee has Rule 45 as unknown' do
        let(:risk) { Risk.new(rule_45: 'unknown') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:rule_45)
          expect(page).not_to have_selector('#rule_45_alert .alert-text')
        end
      end
    end

    context 'E list' do
      context 'when detainee has E list as yes and as standard' do
        let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_standard') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Standard')
        end
      end

      context 'when detainee has E list as yes and as escort' do
        let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_escort') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Escort')
        end
      end

      context 'when detainee has E list as yes and as heightened' do
        let(:risk) { Risk.new(current_e_risk: 'yes', current_e_risk_details: 'e_list_heightened') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to eq('E-List-Heightened')
        end
      end

      context 'when detainee has E list as no' do
        let(:risk) { Risk.new(current_e_risk: 'no') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to be_empty
        end
      end

      context 'when detainee has E list as unknown' do
        let(:risk) { Risk.new(current_e_risk: 'unknown') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:e_list)
          expect(page.find('#e_list_alert .alert-text').text).to be_empty
        end
      end
    end

    context 'CSRA' do
      context 'when detainee has CSRA as high' do
        let(:risk) { Risk.new(csra: 'high') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:csra)
          expect(page).not_to have_selector('#csra_alert .alert-text')
          expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^high$/i)
        end
      end

      context 'when detainee has CSRA as standard' do
        let(:risk) { Risk.new(csra: 'standard') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:csra)
          expect(page).not_to have_selector('#csra_alert .alert-text')
          expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^Standard$/i)
        end
      end

      context 'when detainee has CSRA as unknown' do
        let(:risk) { Risk.new(csra: 'unknown') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:csra)
          expect(page).not_to have_selector('#csra_alert .alert-text')
          expect(page.find('#csra_alert .alert-toggle-text').text).to match(/^Standard$/i)
        end
      end
    end

    context 'Category A' do
      context 'when detainee has Category A as yes' do
        let(:risk) { Risk.new(category_a: 'yes') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:category_a)
          expect(page).not_to have_selector('#category_a_alert .alert-text')
        end
      end

      context 'when detainee has Category A as no' do
        let(:risk) { Risk.new(category_a: 'no') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:category_a)
          expect(page).not_to have_selector('#category_a_alert .alert-text')
        end
      end

      context 'when detainee has Category A as unknown' do
        let(:risk) { Risk.new(category_a: 'unknown') }
        let(:detainee) { FactoryGirl.create(:detainee, risk: risk) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:category_a)
          expect(page).not_to have_selector('#category_a_alert .alert-text')
        end
      end
    end

    context 'MPV' do
      context 'when detainee has MPV as yes' do
        let(:healthcare) { Healthcare.new(mpv: 'yes') }
        let(:detainee) { FactoryGirl.create(:detainee, healthcare: healthcare) }

        scenario 'associated alert is displayed as active' do
          profile.confirm_alert_as_active(:mpv)
          expect(page).not_to have_selector('#mpv_alert .alert-text')
        end
      end

      context 'when detainee has MPV as no' do
        let(:healthcare) { Healthcare.new(mpv: 'no') }
        let(:detainee) { FactoryGirl.create(:detainee, healthcare: healthcare) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:mpv)
          expect(page).not_to have_selector('#mpv_alert .alert-text')
        end
      end

      context 'when detainee has MPV as unknown' do
        let(:healthcare) { Healthcare.new(mpv: 'unknown') }
        let(:detainee) { FactoryGirl.create(:detainee, healthcare: healthcare) }

        scenario 'associated alert is displayed as inactive' do
          profile.confirm_alert_as_inactive(:mpv)
          expect(page).not_to have_selector('#mpv_alert .alert-text')
        end
      end
    end
  end

  context 'move information' do
    context 'detainee with no moves' do
      let(:detainee) { create(:detainee, :with_no_moves) }

      scenario 'does not display any move information' do
        login

        visit detainee_path(detainee)
        expect(page).not_to have_css('.move-information')
        profile.assert_link_to_new_move(detainee)
      end
    end

    context 'detainee with no active move' do
      let(:detainee) { create(:detainee, :with_completed_move) }

      scenario 'does not display any move information' do
        login

        visit detainee_path(detainee)
        expect(page).not_to have_css('.move-information')
        profile.assert_link_to_new_move_from_copy(detainee)
      end
    end

    context 'detainee with an active move' do
      let(:detainee) { create(:detainee, :with_active_move) }

      scenario 'displays all the mandatory move information' do
        login

        visit detainee_path(detainee)
        profile.confirm_move_info(detainee.active_move)
      end
    end
  end

  context 'offences section' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/charges", status: 404)
    end

    let(:detainee) { create(:detainee, :with_active_move, :with_no_offences) }
    let(:active_move) { detainee.active_move }
    let(:current_offences) {
      [
        { name: 'Burglary', case_reference: 'Ref 3064' },
        { name: 'Attempted murder', case_reference: 'Ref 7291' }
      ]
    }
    let(:offences_data) {
      {
        current_offences: current_offences
      }
    }

    shared_examples_for 'offences information display' do
      scenario 'current offences are displayed' do
        profile.confirm_current_offences(current_offences)
      end
    end

    before do
      login

      visit detainee_path(detainee)
      profile.click_edit_offences
      offences.complete_form(offences_data)
    end

    include_examples 'offences information display'

    context 'when there no past offences were filled' do
      let(:offences_data) {
        {
          not_for_release: true,
          not_for_release_details: 'Serving Sentence',
          current_offences: current_offences
        }
      }

      scenario 'current offences are displayed and none past offences' do
        profile.confirm_current_offences(current_offences)
      end
    end
  end
end
