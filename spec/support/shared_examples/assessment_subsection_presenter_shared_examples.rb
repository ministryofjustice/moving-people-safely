RSpec.shared_examples_for 'assessment subsection presenter' do
  include_examples 'assessment section presenter'

  describe '#name' do
    specify { expect(presenter.name).to eq(subsection_name) }
  end

  describe '#questions' do
    context 'when the subsection does not contain any questions' do
      specify { expect(presenter.questions).to eq([]) }
    end

    context 'when the subsection contains a list of questions' do
      let(:subsections_questions) {
        { subsection_name.to_sym => %i[ss_question_1 ss_question_2] }
      }

      before do
        allow(section).to receive(:subsections_questions).and_return(subsections_questions)
      end

      specify { expect(presenter.questions).to match_array(%i[ss_question_1 ss_question_2]) }
    end
  end
end
