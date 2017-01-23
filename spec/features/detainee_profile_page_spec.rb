require 'feature_helper'

RSpec.feature 'detainee profile page', type: :feature do
  let(:detainee) { create(:detainee, :with_active_move, :with_no_offences) }
  let(:active_move) { detainee.active_move }
  let(:current_offences) {
    [
      { name: 'Burglary', case_reference: 'Ref 3064' },
      { name: 'Attempted murder', case_reference: 'Ref 7291' }
    ]
  }
  let(:past_offences) {
    [ { name: 'Arson' }, { name: 'Armed robbery' } ]
  }
  let(:offences_data) {
    {
      release_date: '05/07/2016',
      not_for_release: true,
      not_for_release_details: 'Serving Sentence',
      current_offences: current_offences,
      past_offences: past_offences
    }
  }

  shared_examples_for 'offences information display' do
    scenario 'current and past offences are displayed' do
      profile.confirm_current_offences(current_offences)
      profile.confirm_past_offences(past_offences)
    end
  end

  before do
    login

    visit detainee_path(detainee)
    profile.click_edit_offences
    offences.complete_form(offences_data)
  end

  include_examples 'offences information display'

  context 'when release date is not filled' do
    let(:offences_record) { build(:offences, :empty_record, release_date: nil) }
    let(:detainee) { create(:detainee, :with_active_move, offences: offences_record) }
    let(:offences_data) {
      {
        not_for_release: true,
        not_for_release_details: 'Serving Sentence',
        current_offences: current_offences,
        past_offences: past_offences
      }
    }

    include_examples 'offences information display'
  end

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
      profile.confirm_no_past_offences
    end
  end
end
