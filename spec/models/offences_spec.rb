require 'rails_helper'

RSpec.describe Offences, type: :model do
  it { is_expected.to belong_to(:detainee) }
  subject { FactoryGirl.build(:offences) }

  describe '#all_questions_answered?' do
    context 'when there is no current offences' do
      subject { FactoryGirl.build(:offences, :with_no_current_offences) }

      specify { expect(subject.all_questions_answered?).to be_falsey }
    end

    context 'when there is at least a current offence' do
      before do
        subject.current_offences.build
      end

      specify { expect(subject.all_questions_answered?).to be_truthy }
    end
  end

  describe '#confirm!' do
    let(:user) { build(:user) }
    subject(:offences) { described_class.new }

    context 'when there is no move' do
      it 'raises a StatusChangeError exception' do
        expect { offences.confirm!(user: user) }
          .to raise_error(Offences::StatusChangeError, 'confirm_with_user!')
      end
    end

    context 'when there is a move' do
      let(:detainee) { create(:detainee) }
      let(:offences) { create(:offences, detainee: detainee) }
      let(:move) { create(:move) }
      let!(:escort) { create(:escort, detainee: detainee, move: move) }

      it 'marks the offences data as confirmed' do
        expect {
          offences.confirm!(user: user)
        }.to change { offences.reload.status }.from('not_started').to('confirmed')
      end
    end
  end
end
