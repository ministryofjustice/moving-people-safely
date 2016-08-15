require 'webmock/rspec'
require 'nomis/client'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

RSpec.describe Nomis::Client do
  subject { described_class.new }

  describe '#offender_details' do
    before do
      WebMock.stub_request(:get, 'https://serene-chamber-74280.herokuapp.com/offender_details?noms_id=A1401AE').
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
  end
end
