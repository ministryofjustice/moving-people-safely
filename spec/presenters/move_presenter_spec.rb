require 'rails_helper'

RSpec.describe MovePresenter, type: :presenter do
  let(:move) { create(:move) }
  subject { described_class.new(move) }

  describe '#humanized_date' do
    let(:move) { build(:move, date: Date.civil(2017, 6, 14)) }
    its(:humanized_date) { is_expected.to eq '14 Jun 2017' }
  end

  describe '#not_for_release_text' do
    context 'when not other' do
      let(:move) { build(:move, not_for_release_reason: 'held_for_immigration') }
      its(:not_for_release_text) { is_expected.to eq 'Held for immigration' }
    end

    context 'when other' do
      let(:move) { build(:move, not_for_release_reason: 'other', not_for_release_reason_details: 'Not specified') }
      its(:not_for_release_text) { is_expected.to eq 'Other (Not specified)' }
    end
  end
end
