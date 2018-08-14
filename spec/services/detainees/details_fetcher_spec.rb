require 'rails_helper'

RSpec.describe Detainees::DetailsFetcher do
  let(:prison_number) { 'A1234AB' }
  subject(:fetcher) { described_class.new(prison_number) }

  shared_examples_for 'empty response without API calls' do
    specify {
      response = fetcher.call
      expect(response.to_h).to eq({})
    }

    it 'does not call the NOMIS API' do
      expect(Nomis::Api.instance).not_to receive(:get)
      fetcher.call
    end
  end

  shared_examples_for 'request to NOMIS API' do
    it 'calls the NOMIS API' do
      expect(Nomis::Api.instance)
        .to receive(:get)
        .with("/offenders/#{prison_number}").once
      fetcher.call
    end
  end

  context 'when prison number is nil' do
    let(:prison_number) { nil }
    include_examples 'empty response without API calls'
  end

  context 'when prison number is blank' do
    let(:prison_number) { '' }
    include_examples 'empty response without API calls'
  end

  context 'when NOMIS API response is 404' do
    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 404)
    end

    include_examples 'request to NOMIS API'

    specify {
      response = fetcher.call
      expect(response.to_h).to eq({})
      expect(response.error).to eq('not_found')
    }
  end

  context 'when NOMIS API response is 400' do
    let(:prison_number) { 'invalid-number' }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 400)
    end

    include_examples 'request to NOMIS API'

    specify {
      response = fetcher.call
      expect(response.to_h).to eq({})
      expect(response.error).to eq('invalid_input')
    }
  end

  context 'when NOMIS API response status is 500' do
    let(:prison_number) { 'invalid-number' }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 500)
    end

    include_examples 'request to NOMIS API'

    specify {
      response = fetcher.call
      expect(response.to_h).to eq({})
      expect(response.error).to eq('api_error')
    }
  end

  context 'when NOMIS API response does not contain a valid JSON response' do
    let(:invalid_body) { 'not-valid-json' }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}", body: invalid_body)
    end

    include_examples 'request to NOMIS API'

    specify {
      response = fetcher.call
      expect(response.to_h).to eq({})
      expect(response.error).to eq('api_error')
    }
  end

  context 'when NOMIS API response contains a valid JSON response' do
    let(:given_name) { 'John' }
    let(:middle_names) { 'C.' }
    let(:surname) { 'Doe' }
    let(:date_of_birth) { '1969-01-23' }
    let(:gender) { { 'code' => 'M', 'desc' => 'Male' } }
    let(:ethnicity) { { 'code' => 'EU', 'desc' => 'European' } }
    let(:religion) { { 'code' => 'B', 'desc' => 'Baptist' } }
    let(:nationalities) { 'American' }
    let(:language) { { 'preferred_spoken' => { 'code' => 'WEL-CYM', 'desc' => 'Welsh' }, 'interpreter_required' => false } }
    let(:diet) { { 'code' => 'GLU', 'desc' => 'Medical - Gluten Free Diet' } }
    let(:pnc_number) { '12344' }
    let(:cro_number) { '54321' }
    let(:security_category) { { 'code' => 'A', 'desc' => 'Category A' } }
    let(:valid_body) {
      {
        given_name: given_name,
        middle_names: middle_names,
        surname: surname,
        date_of_birth: date_of_birth,
        gender: gender,
        ethnicity: ethnicity,
        religion: religion,
        nationalities: nationalities,
        language: language,
        diet: diet,
        pnc_number: pnc_number,
        cro_number: cro_number,
        aliases: [],
        security_category: security_category
      }.to_json
    }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}", body: valid_body)
    end

    include_examples 'request to NOMIS API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = {
        prison_number: prison_number,
        forenames: 'JOHN C.',
        surname: 'DOE',
        date_of_birth: '23/01/1969',
        gender: 'male',
        ethnicity: 'European',
        religion: 'Baptist',
        nationalities: 'American',
        language: 'Welsh',
        interpreter_required: 'no',
        diet: 'Medical - Gluten Free Diet',
        pnc_number: '12344',
        cro_number: '54321',
        aliases: nil,
        security_category: 'Category A'
      }.with_indifferent_access
      response = fetcher.call
      expect(response.to_h).to eq(expected_response)
      expect(response.error).to eq(nil)
    end
  end
end
