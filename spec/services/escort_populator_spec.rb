require 'rails_helper'

RSpec.describe EscortPopulator, type: :service do
  let(:escort) { create(:escort, prison_number: 'A1234BC') }

  subject { described_class.new(escort) }

  before do
    data = double(Object)

    detainee_result = double(Object)
    detainee_fetcher = double(Detainees::Fetcher)
    allow(Detainees::Fetcher).to receive(:new).with(escort.prison_number).and_return(detainee_fetcher)
    allow(detainee_fetcher).to receive(:call).and_return(detainee_result)
    allow(detainee_result).to receive(:to_h).and_return(nomis_detainee_attrs)

    offences_result = double(Object)
    offences_fetcher = double(Detainees::OffencesFetcher)
    allow(Detainees::OffencesFetcher).to receive(:new).with(escort.prison_number).and_return(offences_fetcher)
    allow(offences_fetcher).to receive(:call).and_return(offences_result)
    allow(offences_result).to receive(:data).and_return(data)
    allow(data).to receive(:map).and_return(nomis_offences)

    risk_result = double(Object)
    risk_fetcher = double(Detainees::RiskFetcher)
    allow(Detainees::RiskFetcher).to receive(:new).with(escort.prison_number).and_return(risk_fetcher)
    allow(risk_fetcher).to receive(:call).and_return(risk_result)
    allow(risk_result).to receive(:to_h).and_return(nomis_risk_attrs)
  end

  context 'NOMIS API is down' do
    let(:nomis_detainee_attrs) { {} }
    let(:nomis_risk_attrs) { {} }
    let(:nomis_offences) { [] }

    it 'does not create the detainee' do
      subject.call
      expect(escort.detainee).to be_nil
    end

    it 'does not create the risk' do
      subject.call
      expect(escort.risk).to be_nil
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

    let(:nomis_risk_attrs) {
      {
        "self_harm"=>"yes",
        "self_harm_details"=>"Some details",
      }
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

    it 'populates the risk' do
      subject.call

      expect(escort.risk.attributes).to include nomis_risk_attrs
    end
  end
end
