require 'rails_helper'

RSpec.describe EscortPopulator, type: :service do
  let(:escort) { create(:escort, prison_number: 'A1234BC') }

  subject { described_class.new(escort) }

  before do
    result = double(Object)
    data = double(Object)

    detainee_fetcher = double(Detainees::DetailsFetcher)
    allow(Detainees::DetailsFetcher).to receive(:new).with(escort.prison_number).and_return(detainee_fetcher)
    allow(detainee_fetcher).to receive(:call).and_return(result)
    allow(result).to receive(:to_h).and_return(nomis_detainee_attrs)

    offences_fetcher = double(Detainees::OffencesFetcher)
    allow(Detainees::OffencesFetcher).to receive(:new).with(escort.prison_number).and_return(offences_fetcher)
    allow(offences_fetcher).to receive(:call).and_return(result)
    allow(result).to receive(:data).and_return(data)
    allow(data).to receive(:map).and_return(nomis_offences)
  end

  context 'NOMIS API is down' do
    let(:nomis_detainee_attrs) { {} }
    let(:nomis_offences) { [] }

    it 'does not create the detainee' do
      subject.call
      expect(escort.detainee).to be_nil
    end
  end

  context 'NOMIS API is working' do
    let(:nomis_detainee_attrs) {
      {
        "prison_number"=>"A1234XY",
        "forenames"=>"BOB",
        "surname"=>"DYLAN",
        "date_of_birth"=>"24/05/1941",
        "gender"=>"male",
        "nationalities"=>"American",
        "pnc_number"=>"18/320234B",
        "cro_number"=>"68538/69N",
        "ethnicity"=>"White: Eng./Welsh/Scot./N.Irish/British",
        "religion"=>"Rocker",
        "aliases"=>nil,
        "image"=>"/9j/4AAQSkZJ"
      }
    }

    let(:nomis_offences) {
      [
        { "offence" => "Sexual assault of female child under 13", "case_reference" => "T20176487"},
        { "offence" => "Sexual assault of female child under 15", "case_reference" => "T20171974"}
      ]
    }

    it 'populates the detainee' do
      subject.call

      expect(escort.detainee.attributes).to include nomis_detainee_attrs.except('date_of_birth')
      expect(escort.detainee.date_of_birth).to eq Date.parse(nomis_detainee_attrs['date_of_birth'])
    end

    it 'populates the offences' do
      subject.call

      expect(escort.offences.map{ |o| o.slice(:offence, :case_reference) }).to eq nomis_offences
    end
  end
end
