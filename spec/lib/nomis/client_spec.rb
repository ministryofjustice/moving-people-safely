require 'webmock/rspec'
require 'nomis/client'
require 'nomis/error'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

RSpec.describe Nomis::Client do
  subject { described_class.new }

  describe '#offender_details' do
    before do
      stub_request(:get, 'https://serene-chamber-74280.herokuapp.com/offender_details?noms_id=A1401AE').
        to_return(body: "{\"OffenderDetails\":[{\"Working_name\":\"Y\",\"Surname\":\"HALL\",\"Sex\":\"F\",\"Nationalities\":[{\"Nationality\":\"BRITISH\"}, {\"Nationality\":\"SPANISH\"}],\"Forenames\":\"JILLY \",\"Birth_date\":\"1970-01-01\",\"Agency_location\":\"LEEDS (HMP)\", \"CRO_Number\": \"CRO29478\", \"PNC_Number\": \"PNC948223\"}]}")
    end

    it 'returns a list of details value objects' do
      result = subject.offender_details(prison_number: 'A1401AE')

      expect(result.size).to eq 1
      expect(result[0].agency_location).to eq "LEEDS (HMP)"
      expect(result[0].birth_date).to eq Date.civil(1970, 1, 1)
      expect(result[0].cro_number).to eq "CRO29478"
      expect(result[0].forenames).to eq "Jilly"
      expect(result[0].surname).to eq "Hall"
      expect(result[0].pnc_number).to eq "PNC948223"
      expect(result[0].sex).to eq "female"
      expect(result[0].current?).to be true
      expect(result[0].working_name).to be true
      expect(result[0].nationalities).to eq "British and Spanish"
    end

    context 'handling errors' do
      context 'timeouts' do
        before do
          stub_request(:get,'https://serene-chamber-74280.herokuapp.com/offender_details?noms_id=A1401AE').to_timeout
        end

        it 'raises a RequestTimeout error' do
          expect { subject.offender_details(prison_number: 'A1401AE') }.
            to raise_error(Nomis::Error::RequestTimeout)
        end
      end

      context 'invalid response' do
        before do
          stub_request(:get,'https://serene-chamber-74280.herokuapp.com/offender_details?noms_id=A1401AE').
            to_return(body: 'Invalid')
        end

        it 'raises an InvalidResponse error' do
          expect { subject.offender_details(prison_number: 'A1401AE') }.
            to raise_error(Nomis::Error::InvalidResponse)
        end
      end
    end
  end
end
