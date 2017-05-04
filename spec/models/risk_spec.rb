require 'rails_helper'

RSpec.describe Risk, type: :model do
  it { is_expected.to belong_to(:escort) }
  it_behaves_like 'questionable'

  def create_escort
    create(:escort, detainee: detainee, move: move, risk: risk)
  end

  let(:detainee) { create(:detainee) }
  let(:move) { create(:move) }

  subject(:risk) { described_class.new }

  describe '#confirm!' do
    let(:user) { build(:user) }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
        expect { risk.confirm!(user: user) }
          .to raise_error(Risk::StatusChangeError, 'confirm_with_user!')
      end
    end

    context 'when there is a move' do
      before { create_escort }

      it 'marks the risk assessment as confirmed' do
        expect {
          risk.confirm!(user: user)
        }.to change { risk.reload.status }.from('not_started').to('confirmed')
      end
    end
  end

  describe '#not_started!' do
    let(:user) { build(:user) }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
        expect { risk.not_started! }
          .to raise_error(Risk::StatusChangeError, 'not_started!')
      end
    end

    context 'when there is a move' do
      before { create_escort }

      it 'marks the risk assessment as not started' do
        risk.unconfirmed!
        expect {
          risk.not_started!
        }.to change { risk.reload.status }.from('unconfirmed').to('not_started')
      end
    end
  end

  describe '#unconfirmed!' do
    let(:user) { build(:user) }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
        expect { risk.unconfirmed! }
          .to raise_error(Risk::StatusChangeError, 'unconfirmed!')
      end
    end

    context 'when there is a move' do
      before { create_escort }

      it 'marks the risk assessment as uncorfirmed' do
        expect {
          risk.unconfirmed!
        }.to change { risk.reload.status }.from('not_started').to('unconfirmed')
      end
    end
  end

  describe '#incomplete!' do
    let(:user) { build(:user) }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
          expect { risk.incomplete! }
          .to raise_error(Risk::StatusChangeError, 'incomplete!')
      end
    end

    context 'when there is a move' do
      before { create_escort }

      it 'marks the risk assessment as incomplete' do
        expect {
          risk.incomplete!
        }.to change { risk.reload.status }.from('not_started').to('incomplete')
      end
    end
  end

  describe '#schema' do
    it 'returns an object representation of the risk schema' do
      expect(subject.schema).to be_an_instance_of(Schemas::Assessment)
    end
  end
end
