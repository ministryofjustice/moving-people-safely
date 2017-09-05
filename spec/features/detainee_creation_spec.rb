require 'feature_helper'

RSpec.feature 'Detainee creation', type: :feature do
  let(:prison_number) { 'AB123' }
  let(:escort) { create(:escort, prison_number: prison_number) }

  context 'when detainee pre-filled information cannot be retrieved' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 500)
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
    end

    scenario 'filling detainee details manually' do
      login

      visit new_escort_detainee_path(escort, prison_number: prison_number)
      new_detainee_page.assert_unprefilled_form(prison_number)
    end
  end

  context 'when detainee pre-filled information is retrieved' do
    let(:successful_body) {
      {
        given_name: 'John',
        middle_names: 'C.',
        surname: 'Doe',
        date_of_birth: '11-09-1975',
        gender: { 'code' => 'M', 'desc' => 'Male'},
        ethnicity: { 'code' => 'EU', 'desc' => 'European'},
        religion: { 'code' => 'B', 'desc' => 'Baptist'},
        nationalities: 'British',
        pnc_number: '12345',
        cro_number: '112233'
      }.to_json
    }
    let(:expected_field_values) {
      {
        surname: 'DOE',
        forenames: 'JOHN C.',
        date_of_birth: '11/09/1975',
        nationalities: 'British',
        gender: 'male',
        religion: 'Baptist',
        ethnicity: 'European',
        pnc_number: '12345',
        cro_number: '112233'
      }
    }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}", body: successful_body)
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
    end

    scenario 'detainee details are prefilled in the form' do
      login

      visit new_escort_detainee_path(escort, prison_number: prison_number)
      new_detainee_page.assert_prefilled_form(expected_field_values)
    end
  end

  context 'when detainee image cannot be retrieved' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}")
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 500)
    end

    scenario 'display an image placeholder' do
      login

      visit new_escort_detainee_path(escort, prison_number: prison_number)
      new_detainee_page.assert_form_with_image_placeholder
    end
  end

  context 'when detainee image is retrieved but is empty' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}")
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: nil }.to_json)
    end

    scenario 'display an image placeholder' do
      login

      visit new_escort_detainee_path(escort, prison_number: prison_number)
      new_detainee_page.assert_form_with_image_placeholder
    end
  end

  context 'when detainee image is retrieved and has content' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}")
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: 'base64-enconded-image' }.to_json)
    end

    scenario 'display the retrieved detainee image' do
      login

      visit new_escort_detainee_path(escort, prison_number: prison_number)
      new_detainee_page.assert_form_with_detainee_image
    end
  end
end
