require 'rails_helper'

RSpec.describe Detainees::RiskFetcher do
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
        .with("/offenders/#{prison_number}/alerts?include_inactive=true").once
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts?include_inactive=true", status: 404)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts?include_inactive=true", status: 400)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts?include_inactive=true", status: 500)
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
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts?include_inactive=true", body: invalid_body)
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
                  "code" => "X",
                  "desc" => "Security"
                },
              "alert_sub_type" =>
                {
                  "code" => "XEL",
                  "desc" => "Escape List"
                },
              "alert_date" => "2018-01-12",
              "status" => "ACTIVE",
              "comment" => "has a large poster on cell wall"
            },
            {
              "alert_type" =>
                {
                  "code" => "R",
                  "desc" => "Risk"
                },
              "alert_sub_type":
                {
                  "code" => "RKS",
                  "desc" => "Risk to Known Adult - Custody"
                },
              "alert_date" => 5.days.ago.to_date.to_s(:db),
              "expiry_date" => 20.days.from_now.to_date.to_s(:db),
              "status" => "ACTIVE"
            }
          ]
      }.to_json
    }

    before do
      stub_nomis_api_request(:get, "/offenders/#{prison_number}/alerts?include_inactive=true", body: valid_body)
    end

    include_examples 'request to NOMIS API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = {
        self_harm: "no",
        rule_45: "no",
        vulnerable_prisoner: "no",
        controlled_unlock: "no",
        high_profile: "no",
        intimidation_public: "yes",
        intimidation_prisoners: "yes",
        gang_member: "no",
        violence_to_staff: "no",
        risk_to_females: "no",
        homophobic: "no",
        racist: "no",
        discrimination_to_other_religions: "no",
        current_e_risk: "yes",
        current_e_risk_details: "has a large poster on cell wall",
        previous_escape_attempts: "no",
        hostage_taker: "no",
        sex_offence: "no",
        arson: "no",
        must_return: "no",
        has_must_not_return_details: "no",
        other_risk: "no",
        violent_or_dangerous: "no"
      }.with_indifferent_access
      response = fetcher.call
      expect(response.to_h).to eq(expected_response)
      expect(response.error).to eq(nil)
    end
  end
end
