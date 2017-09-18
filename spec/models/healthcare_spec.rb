require 'rails_helper'

RSpec.describe Healthcare, type: :model do
  it { is_expected.to be_a(Questionable) }
  it { is_expected.to be_a(Reviewable) }

  it { is_expected.to belong_to(:escort) }

  it { is_expected.to delegate_method(:editable?).to(:escort) }

  subject { described_class.new }

  include_examples 'reviewable'

  describe '#default_contact_number' do
    context 'when there is no current establishment set for the detainee' do
      before do
        expect(subject).to receive(:current_establishment).and_return(nil)
      end

      specify { expect(subject.default_contact_number).to be_nil }
    end

    context 'when there is a current establishment set for the detainee' do
      let(:establishment) { double(Establishment, default_healthcare_contact_number: '111111') }

      before do
        expect(subject).to receive(:current_establishment).and_return(establishment)
      end

      it 'returns the default healthcare contact number for that establishment' do
        expect(subject.default_contact_number).to eq('111111')
      end
    end
  end
end
