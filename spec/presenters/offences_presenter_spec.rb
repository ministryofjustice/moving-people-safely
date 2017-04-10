require 'rails_helper'

RSpec.describe OffencesPresenter, type: :presenter do
  describe '#all_questions_answered?' do
    subject { described_class.new(offences) }

    context 'when there is no current offences' do
      let(:offences) { [] }

      specify { expect(subject.all_questions_answered?).to be_falsey }
    end

    context 'when there is at least a current offence' do
      let(:offences) { build_list(:offence, rand(1..5))  }

      specify { expect(subject.all_questions_answered?).to be_truthy }
    end
  end
end