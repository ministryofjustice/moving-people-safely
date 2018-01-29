require 'feature_helper'

RSpec.feature 'Adding offences to a move', type: :feature do
  let(:prison_number) { 'A45345DQ' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:move) { create(:move) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee, move: move) }
  let(:fixture_json_file_path) { Rails.root.join('spec', 'support', 'fixtures', 'valid-nomis-charges.json') }
  let(:valid_json) { File.read(fixture_json_file_path) }

  before do
    login
    visit escort_path(escort)
  end

  let(:expected_offences_after_ammendment) {
    [
      { name: "Updated text (NEW_REFERENCE)" },
      { name: "Some other description (ANOTHER_REFERENCE)" }
    ]
  }

  scenario 'ammending pre populated offences' do
    stub_nomis_api_request(:get, "/offenders/#{detainee.prison_number}/charges", body: valid_json)

    escort_page.click_edit_offences
    offences.update(index: 0, description: "Updated text", case_reference: "NEW_REFERENCE")
    offences.add(description: "Some other description", case_reference: "ANOTHER_REFERENCE")
    offences.save_and_continue
    escort_page.confirm_offences(expected_offences_after_ammendment)
  end
end
