require 'rails_helper'

RSpec.describe Risk, type: :model do
  it { is_expected.to belong_to(:escort) }
  it { is_expected.to be_a(Questionable) }

  def create_escort
    create(:escort, detainee: detainee, move: move, risk: risk)
  end

  let(:detainee) { create(:detainee) }
  let(:move) { create(:move) }

  subject(:risk) { described_class.new }

  describe '#confirm!' do
    let(:user) { build(:user) }

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
end
