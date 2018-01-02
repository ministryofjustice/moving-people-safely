require 'rails_helper'

RSpec.describe Move, type: :model do
  subject { described_class.new }

  describe '#not_for_release_text' do
    context 'when not_for_release_reason is not other' do
      subject { build(:move, not_for_release_reason: 'held_for_immigration') }
      its(:not_for_release_text) { is_expected.to eq 'Held for immigration' }
    end

    context 'when not_for_release_reason is other' do
      subject { build(:move, not_for_release_reason: 'other', not_for_release_reason_details: 'Not specified') }
      its(:not_for_release_text) { is_expected.to eq 'Other (Not specified)' }
    end
  end
end
