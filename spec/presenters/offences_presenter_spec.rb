require 'rails_helper'

RSpec.describe OffencesPresenter, type: :presenter do
  describe '#all_questions_answered?' do
    subject { described_class.new(current_offences) }

    context 'when there is no current offences' do
      let(:current_offences) { [] }

      specify { expect(subject.all_questions_answered?).to be_falsey }
    end

    context 'when there is at least a current offence' do
      let(:current_offences) { build_list(:current_offence, rand(1..5))  }

      specify { expect(subject.all_questions_answered?).to be_truthy }
    end
  end
end