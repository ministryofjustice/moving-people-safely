require 'rails_helper'

RSpec.describe Detainees::ImageFetcher do
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
        .with("/offenders/#{prison_number}/image").once
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

  context 'when NOMIS API response is 400' do
    let(:prison_number) { 'invalid-number' }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 400)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 500)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: invalid_body)
    end

    include_examples 'request to NOMIS API'

    specify {
      response = fetcher.call
      expect(response.to_h).to eq({})
      expect(response.error).to eq('api_error')
    }
  end

  context 'when NOMIS API response contains a valid JSON response' do
    let(:valid_body) { { image: 'base-64-encoded-image' }.to_json }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: valid_body)
    end

    context 'but the response has no image content' do
      let(:valid_body) { { image: nil }.to_json }

      include_examples 'request to NOMIS API'

      it 'returns an empty hash and an not found error' do
        response = fetcher.call
        expect(response.to_h).to eq({})
        expect(response.error).to eq('not_found')
      end
    end

    include_examples 'request to NOMIS API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = { image: 'base-64-encoded-image' }.with_indifferent_access
      response = fetcher.call
      expect(response.to_h).to eq(expected_response)
      expect(response.error).to eq(nil)
    end
  end
end
