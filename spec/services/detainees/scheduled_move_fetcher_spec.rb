require 'rails_helper'

RSpec.describe Detainees::ScheduledMoveFetcher do
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
        alerts:
          [
            {
              "alert_type"=>{"code"=>"X", "desc"=>"Security"},
              "alert_sub_type"=>{"code"=>"XNR", "desc"=>"Not For Release"},
              "alert_date"=>"2009-12-22",
              "status"=>"ACTIVE",
              "comment"=>"DiaHNZYoTthiDiaHNZYoTth"
            },
            {
              "alert_type"=>{"code"=>"S", "desc"=>"Sexual Offence"},
              "alert_sub_type"=>{"code"=>"SOR", "desc"=>"Registered sex offender"},
              "alert_date"=>"2016-08-02",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"T", "desc"=>"Hold Against Transfer"},
              "alert_sub_type"=>{"code"=>"TPR", "desc"=>"Parole Review Hold"},
              "alert_date"=>"2016-08-05",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"P", "desc"=>"MAPPP Case"},
              "alert_sub_type"=>{"code"=>"PL1", "desc"=>"MAPPA Level 1"},
              "alert_date"=>"2016-08-15",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"P", "desc"=>"MAPPP Case"},
              "alert_sub_type"=>{"code"=>"PVN", "desc"=>"ViSOR Nominal"},
              "alert_date"=>"2016-08-16",
              "status"=>"ACTIVE",
              "comment"=>"KasaaKasaa"
            },
            {
              "alert_type"=>{"code"=>"P", "desc"=>"MAPPP Case"},
              "alert_sub_type"=>{"code"=>"PC1", "desc"=>"MAPPA Cat 1"},
              "alert_date"=>"2016-08-18",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"X", "desc"=>"Security"},
              "alert_sub_type"=>{"code"=>"XA", "desc"=>"Arsonist"},
              "alert_date"=>"2018-11-05",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"X", "desc"=>"Security"},
              "alert_sub_type"=>{"code"=>"XEL", "desc"=>"Escape List"},
              "alert_date"=>"2018-11-05",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"X", "desc"=>"Security"},
              "alert_sub_type"=>{"code"=>"XRF", "desc"=>"Risk to Females"},
              "alert_date"=>"2018-11-05",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"X", "desc"=>"Security"},
              "alert_sub_type"=>{"code"=>"XSA", "desc"=>"Staff Assaulter"},
              "alert_date"=>"2018-11-05",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"H", "desc"=>"Self Harm"},
              "alert_sub_type"=>{"code"=>"HA", "desc"=>"ACCT Open (HMPS)"},
              "alert_date"=>"2018-11-05",
              "status"=>"ACTIVE"
            },
            {
              "alert_type"=>{"code"=>"X", "desc"=>"Security"},
              "alert_sub_type"=>{"code"=>"XTACT", "desc"=>"Terrorism Act or Related Offence"},
              "alert_date"=>"2018-11-05",
              "status"=>"ACTIVE"
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
        violent: 'no',
        suicide: 'yes',
        self_harm: 'yes',
        escape_risk: 'yes',
        segregation: 'no',
        medical: 'no'
      }.with_indifferent_access
      response = fetcher.call
      expect(response.to_h).to eq(expected_response)
      expect(response.error).to eq(nil)
    end
  end
end
