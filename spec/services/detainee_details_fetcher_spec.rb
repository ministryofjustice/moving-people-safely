require 'rails_helper'

RSpec.describe DetaineeDetailsFetcher do
  let(:prison_number) { 'ABC123' }
  subject(:fetcher) { described_class.new(prison_number) }

  shared_examples_for 'empty response without API calls' do
    specify {
      response = fetcher.call
      expect(response.details).to eq({})
    }

    it 'does not call the Offenders API' do
      expect(Rails.offenders_api_client).not_to receive(:get)
      fetcher.call
    end
  end

  shared_examples_for 'request to Offenders API' do
    it 'calls the Offenders API' do
      expect(Rails.offenders_api_client)
        .to receive(:get)
        .with('/offenders/search', params: { noms_id: prison_number})
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

  context 'when Offenders API response is not 200' do
    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { status: 201 })
    end

    include_examples 'request to Offenders API'

    specify {
      response = fetcher.call
      expect(response.details).to eq({})
      expect(response.error).to eq('api_error')
    }
  end

  context 'when Offenders API response does not contain a valid JSON response' do
    let(:invalid_body) { 'not-valid-json' }
    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { body: invalid_body, status: 200 })
    end

    include_examples 'request to Offenders API'

    specify {
      response = fetcher.call
      expect(response.details).to eq({})
      expect(response.error).to eq('api_error')
    }
  end

  context 'when Offenders API response contains a valid JSON response' do
    let(:given_name) { 'John' }
    let(:middle_names) { 'C.' }
    let(:surname) { 'Doe' }
    let(:date_of_birth) { '1969-01-23' }
    let(:gender) { 'm' }
    let(:nationality_code) { 'FR' }
    let(:pnc_number) { '12344' }
    let(:cro_number) { '54321' }
    let(:valid_body) {
      [{
        noms_id: prison_number,
        given_name: given_name,
        middle_names: middle_names,
        surname: surname,
        date_of_birth: date_of_birth,
        gender: gender,
        nationality_code: nationality_code,
        pnc_number: pnc_number,
        cro_number: cro_number
      }].to_json
    }

    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { body: valid_body, status: 200 })
    end

    include_examples 'request to Offenders API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = {
        prison_number: prison_number,
        forenames: 'John C.',
        surname: 'Doe',
        date_of_birth: '23/01/1969',
        gender: 'male',
        nationalities: 'French',
        pnc_number: '12344',
        cro_number: '54321'
      }.with_indifferent_access
      response = fetcher.call
      expect(response.details).to eq(expected_response)
      expect(response.error).to eq(nil)
    end
  end
end
