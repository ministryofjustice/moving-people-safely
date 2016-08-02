require 'rails_helper'

RSpec.describe Offences, type: :model do
  it { is_expected.to belong_to(:detainee) }
  subject { build :offences }

  describe '#all_questions_answered?' do
    context 'when all questions have been answered' do
      it 'returns true' do
        subject.current_offences.build
        expect(subject.all_questions_answered?).to be true
      end
    end

    context 'when not all questions have been answered' do
      it 'returns false' do
        subject.release_date = nil
        expect(subject.all_questions_answered?).to be false
      end
    end
  end
end
