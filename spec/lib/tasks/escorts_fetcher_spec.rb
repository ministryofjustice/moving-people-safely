require 'rails_helper'

RSpec.describe CompareAutoAlerts::EscortsFetcher do
  subject { described_class.new(limit).compare(alerts) }

  let(:limit) { 1 }
  let!(:escort) do
    create(:escort, :with_move, :with_complete_risk_assessment)
  end

  let(:alerts) do
    { escort.prison_number => { 'foo' => true } }
  end

  let(:mapper) { double('RiskMapper', call: automated_risks) }
  let(:automated_risks) do
    { 'arson' => 'no' }
  end

  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(Detainees::RiskMapper).to receive(:new).and_return(mapper)
  end

  describe '#compare' do
    it 'populates prison number with alerts' do
      expect(subject[escort.prison_number]).to include(
          to_type: escort.move.to_type,
          comparison: {
            'arson' => {
              human: 'no',
              auto: 'no',
              outcome: 'MATCH'
            }
          })
    end
  end
end
