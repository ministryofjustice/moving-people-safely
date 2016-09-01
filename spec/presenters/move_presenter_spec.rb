require 'rails_helper'

RSpec.describe MovePresenter, type: :presenter do
  let(:move) { create :move }
  subject { described_class.new move }

  describe '#humanized_date' do
    let(:move) { build :move, date: Date.civil(2017, 6, 14) }
    its(:humanized_date) { is_expected.to eq '14 Jun 2017' }
  end

  describe '#humanized_reason' do
    context 'when not other' do
      let(:move) { build :move, reason: 'discharge_to_court' }
      its(:humanized_reason) { is_expected.to eq 'Discharge to court' }
    end

    context 'when other' do
      let(:move) { build :move, reason: 'other', reason_details: 'other reasons' }
      its(:humanized_reason) { is_expected.to eq 'other reasons' }
    end
  end
end
