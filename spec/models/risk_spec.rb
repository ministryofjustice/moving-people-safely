require 'rails_helper'

RSpec.describe Risk, type: :model do
  it { is_expected.to belong_to(:escort) }
  it { is_expected.to be_a(Questionable) }

  def create_escort
    create(:escort, detainee: detainee, move: move, risk: risk)
  end

  let(:detainee) { create(:detainee) }
  let(:move) { create(:move) }
  let(:user) { build(:user) }

  subject(:risk) { described_class.new }

  describe '#confirm!' do

    before { create_escort }

    context 'when the risk assessment is not confirmed' do
      it 'marks the risk assessment as confirmed' do
        expect {
          risk.confirm!(user: user)
        }.to change { risk.reload.status }.from('incomplete').to('confirmed')
      end
    end

    context 'when the risk assessment is already confirmed' do
      subject(:risk) { described_class.new(status: Risk::STATES[:confirmed]) }

      it 'marks the risk assessment as confirmed' do
        expect {
          risk.confirm!(user: user)
        }.to_not change { risk.reload.status }
      end
    end
  end

  describe '#reviewed?' do
    context 'when has been reviewed' do
      subject { described_class.new(reviewer: user, reviewed_at: 1.day.ago)}
      specify { expect(subject.reviewed?).to be_truthy }
    end

    context 'when has not been reviewed' do
      specify { expect(subject.reviewed?).to be_falsey }
    end
  end
end
