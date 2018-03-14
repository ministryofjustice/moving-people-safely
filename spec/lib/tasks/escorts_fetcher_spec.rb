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

  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(Detainees::RiskMapper).to receive(:new).and_return(mapper)
  end

  describe '#compare' do
    context 'Auto and human match' do
      let(:automated_risks) { { 'arson' => 'no' } }

      it 'indicates MATCH' do
        expect(subject[escort.prison_number]).to include(
          to_type: escort.move.to_type,
          comparison: {
            'arson' => { human: 'no', auto: 'no', outcome: 'MATCH' }
          }
        )
      end
    end

    context 'Auto and human differ' do
      let(:automated_risks) { { 'arson' => 'yes' } }

      it 'indicates DIFFER' do
        expect(subject[escort.prison_number]).to include(
          to_type: escort.move.to_type,
          comparison: {
            'arson' => { human: 'no', auto: 'yes', outcome: 'DIFFER' }
          }
        )
      end
    end

    context 'Auto says negative but human says positive' do
      let(:automated_risks) { { 'arson' => 'no' } }

      before { escort.risk.update_column(:arson, 'yes') }

      it 'indicates FALSE_NEGATIVE' do
        expect(subject[escort.prison_number]).to include(
          to_type: escort.move.to_type,
          comparison: {
            'arson' => { human: 'yes', auto: 'no', outcome: 'FALSE_NEGATIVE' }
          }
        )
      end
    end
  end
end
