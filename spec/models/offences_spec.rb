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
end
