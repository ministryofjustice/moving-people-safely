require 'rails_helper'

RSpec.describe Healthcare, type: :model do
  it { is_expected.to be_a(Questionable) }
  it { is_expected.to be_a(Reviewable) }

  it { is_expected.to belong_to(:escort) }

  it { is_expected.to delegate_method(:editable?).to(:escort) }

  subject { described_class.new }

  include_examples 'reviewable'

  describe '#set_default_values' do
    context 'when there is no establishment' do
      specify { expect(subject.contact_number).to be_nil }
    end

    context 'when there is an establishment set in the move' do
      let(:establishment) { create(:establishment, healthcare_contact_number: '111111') }
      let(:move) { create(:move, from_establishment: establishment) }
      let(:escort) { create(:escort, move: move) }

      subject { described_class.new(escort: escort) }

      it 'returns the default healthcare contact number for that establishment' do
        expect(subject.contact_number).to eq('111111')
      end
    end
  end
end
