require 'rails_helper'

RSpec.describe Detainees::OffencesFetcher do
  let(:prison_number) { 'A1234AB' }
  subject(:result) { described_class.new(prison_number).call }
  
  context 'unsuccessful api calls' do
    context 'when the NOMIS API response is 400' do
      before do
        stub_charges_api_request(status: 400)
      end
      
      specify {
        expect(result.data).to eq({})
        expect(result.error).to eq('invalid_input')
      }
    end
    
    context 'when the NOMIS API response is 404' do
      before do
        stub_charges_api_request(status: 404)
      end
      
      specify {
        expect(result.data).to eq({})
        expect(result.error).to eq('not_found')
      }
    end
    
    context 'when the NOMIS API response is 500' do
      before do
        stub_charges_api_request(status: 500)
      end
      
      specify {
        expect(result.data).to eq({})
        expect(result.error).to eq('api_error')
      }
    end
    
    context 'when the NOMIS API returns invalid JSON' do
      before do
        stub_charges_api_request(body: 'invalid-json')
      end
      
      specify {
        expect(result.data).to eq({})
        expect(result.error).to eq('api_error')
      }
    end
  end
  
  context 'when the NOMIS API returns a valid JSON response' do
    let(:fixture_json_file_path) { 
      Rails.root.join('spec', 'support', 'fixtures', 'valid-nomis-charges.json')
    }
    let(:valid_json) { File.read(fixture_json_file_path) }
    
    before do
      stub_charges_api_request(body: valid_json)
    end
    
    it 'transforms the api response returning offence data' do
      offence_attributes = result.data.map(&:attributes)
      
      expect(offence_attributes).to match_array(
        [
          { 
            offence: 'Attempt burglary dwelling with intent to inflict grievous bodily harm',
            case_reference: 'T20117495'
          },
          { 
            offence: 'Abstract / use without authority electricity',
            case_reference: 'T20117495'
          }
        ]
      )
    end
  end
  
  def stub_charges_api_request(options)
    stub_nomis_api_request(:get, "/offenders/#{prison_number}/charges", options)
  end
end