require 'rails_helper'

RSpec.describe Healthcare, type: :model do
  it { is_expected.to belong_to(:escort) }
  it { is_expected.to be_a(Questionable) }

  def create_escort
    create(:escort, detainee: detainee, move: move, healthcare: healthcare)
  end

  let(:detainee) { create(:detainee) }
  let(:move) { create(:move) }

  subject(:healthcare) { described_class.new }

  describe '#confirm!' do
    let(:user) { build(:user) }

    before { create_escort }

    context 'when the risk assessment is not confirmed' do
      it 'marks the healthcare assessment as confirmed' do
        expect {
          healthcare.confirm!(user: user)
        }.to change { healthcare.reload.status }.from('incomplete').to('confirmed')
      end
    end

    context 'when the risk assessment is already confirmed' do
      subject(:healthcare) { described_class.new(status: Healthcare::STATES[:confirmed]) }

      it 'marks the healthcare assessment as confirmed' do
        expect {
          healthcare.confirm!(user: user)
        }.to_not change { healthcare.reload.status }
      end
    end
  end

  describe '#default_contact_number' do
    context 'when there is no current establishment set for the detainee' do
      before do
        expect(healthcare).to receive(:current_establishment).and_return(nil)
      end

      specify { expect(healthcare.default_contact_number).to be_nil }
    end

    context 'when there is a current establishment set for the detainee' do
      let(:establishment) { double(Establishment, default_healthcare_contact_number: '111111') }

      before do
        expect(healthcare).to receive(:current_establishment).and_return(establishment)
      end

      it 'returns the default healthcare contact number for that establishment' do
        expect(healthcare.default_contact_number).to eq('111111')
      end
    end
  end
end
