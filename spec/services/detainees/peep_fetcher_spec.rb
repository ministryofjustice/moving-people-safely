require 'rails_helper'

RSpec.describe Detainees::PeepFetcher do
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
        .with("/offenders/#{prison_number}/alerts").once
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts", status: 404)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts", status: 400)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts", status: 500)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts", body: invalid_body)
    end

    include_examples 'request to NOMIS API'

    specify {
      response = fetcher.call
      expect(response.to_h).to eq({})
      expect(response.error).to eq('api_error')
    }
  end

  context 'when NOMIS API response contains a valid JSON response' do
    let(:valid_body) {
      {
        "alerts":
          [
            {
              "alert_type" =>
                {
                  "code" => "M",
                  "desc" => "Medical"
                },
              "alert_sub_type" =>
                {
                  "code" => "PEEP",
                  "desc" => "Personal Emergency Evacuation Plan"
                },
              "alert_date" => "2018-01-12",
              "status" => "ACTIVE",
              "comment" => "PEEP in Place - Reduced Mobility"
            }
          ]
      }.to_json
    }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts", body: valid_body)
    end

    include_examples 'request to NOMIS API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = {
        peep: "yes",
        peep_details: "PEEP in Place - Reduced Mobility"
      }
      response = fetcher.call
      expect(response.to_h).to eq(expected_response)
    end
  end

  context 'when NOMIS API response contains a valid empty JSON response' do
    let(:valid_body) { { "alerts": [] }.to_json }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts", body: valid_body)
    end

    include_examples 'request to NOMIS API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = {
        peep: "no",
        peep_details: nil
      }
      response = fetcher.call
      expect(response.to_h).to eq(expected_response)
    end
  end

  context 'when NOMIS API response contains a nil response' do
    let(:valid_body) { nil }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts", body: valid_body)
    end

    include_examples 'request to NOMIS API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = {}
      response = fetcher.call
      expect(response.to_h).to eq(expected_response)
    end
  end
end
