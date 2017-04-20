require 'rails_helper'

RSpec.describe Healthcare, type: :model do
  it { is_expected.to belong_to(:detainee) }
  it { is_expected.to have_many(:medications).dependent(:destroy) }
  it_behaves_like 'questionable'

  describe '#confirm!' do
    let(:user) { build(:user) }
    subject(:healthcare) { described_class.new }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
        expect { healthcare.confirm!(user: user) }
          .to raise_error(Healthcare::StatusChangeError, 'confirm_with_user!')
      end
    end

    context 'when there is a move' do
      let(:detainee) { create(:detainee) }
      let(:healthcare) { create(:healthcare, detainee: detainee) }
      let(:move) { create(:move) }
      let!(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'marks the healthcare assessment as confirmed' do
        expect {
          healthcare.confirm!(user: user)
        }.to change { healthcare.reload.status }.from('not_started').to('confirmed')
      end
    end
  end

  describe '#not_started!' do
    let(:user) { build(:user) }
    subject(:healthcare) { described_class.new }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
        expect { healthcare.not_started! }
          .to raise_error(Healthcare::StatusChangeError, 'not_started!')
      end
    end

    context 'when there is a move' do
      let(:detainee) { create(:detainee) }
      let(:healthcare) { create(:healthcare, detainee: detainee) }
      let(:move) { create(:move) }
      let!(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'marks the healthcare assessment as not started' do
        healthcare.unconfirmed!
        expect {
          healthcare.not_started!
        }.to change { healthcare.reload.status }.from('unconfirmed').to('not_started')
      end
    end
  end

  describe '#unconfirmed!' do
    let(:user) { build(:user) }
    subject(:healthcare) { described_class.new }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
        expect { healthcare.unconfirmed! }
          .to raise_error(Healthcare::StatusChangeError, 'unconfirmed!')
      end
    end

    context 'when there is a move' do
      let(:detainee) { create(:detainee) }
      let(:healthcare) { create(:healthcare, detainee: detainee) }
      let(:move) { create(:move) }
      let!(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'marks the healthcare assessment as uncorfirmed' do
        expect {
          healthcare.unconfirmed!
        }.to change { healthcare.reload.status }.from('not_started').to('unconfirmed')
      end
    end
  end

  describe '#incomplete!' do
    let(:user) { build(:user) }
    subject(:healthcare) { described_class.new }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
          expect { healthcare.incomplete! }
          .to raise_error(Healthcare::StatusChangeError, 'incomplete!')
      end
    end

    context 'when there is a move' do
      let(:detainee) { create(:detainee) }
      let(:healthcare) { create(:healthcare, detainee: detainee) }
      let(:move) { create(:move) }
      let!(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'marks the healthcare assessment as incomplete' do
        expect {
          healthcare.incomplete!
        }.to change { healthcare.reload.status }.from('not_started').to('incomplete')
      end
    end
  end
end
