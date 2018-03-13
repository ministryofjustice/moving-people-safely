require 'rails_helper'

RSpec.describe CompareAutoAlerts::NomisCache do
  subject { described_class.new(limit) }

  let(:limit) { 1 }
  let(:nomis_client) { double('NomisClient', get: nomis_alerts) }
  let(:prison_number) { 'foo' }
  let(:prison_numbers) { [ prison_number ] }
  let(:nomis_alerts) { { 'bish' => 'bosh' } }
  let(:file_ref) { double('FileRef', write: nil) }

  before do
    allow(Nomis::Api).to receive(:instance).and_return(nomis_client)
    allow(File).to receive(:open).and_return(file_ref)
    allow(File).to receive(:exist?).and_return(false)
  end

  describe '#refresh' do
    it 'populates prison number with alerts' do
      subject.refresh(prison_numbers)
      expect(subject.alerts).to eq( { prison_number => nomis_alerts } )
    end
  end
end
