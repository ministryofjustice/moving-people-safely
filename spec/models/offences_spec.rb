require 'rails_helper'

RSpec.describe Offences, type: :model do
  it { is_expected.to belong_to(:detainee) }
  let(:release_date) { Date.tomorrow.strftime('%d/%m/%Y') }
  let(:options) { { release_date: release_date } }
  subject { build(:offences, options) }

  describe '#all_questions_answered?' do
    context 'when release date is not present' do
      let(:release_date) { nil }
      specify { expect(subject.all_questions_answered?).to be_truthy }
    end

    context 'when there is no current offences' do
      subject { build(:offences, :with_no_current_offences, options) }

      specify { expect(subject.all_questions_answered?).to be_falsey }
    end

    context 'when there is at least a current offence' do
      before do
        subject.current_offences.build
      end

      specify { expect(subject.all_questions_answered?).to be_truthy }
    end
  end
end
