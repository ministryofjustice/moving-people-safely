RSpec.shared_examples_for 'print assessment subsection presenter' do
  before do
    allow(presenter).to receive(:section).and_return(section)
    allow(model).to receive(:question).and_return(answer)
    allow(model).to receive(:conditional_question).and_return(conditional_answer)
  end

  describe '#name' do
    specify { expect(presenter.name).to eq(subsection_name) }
  end

  describe '#questions' do
    context 'when the subsection does not contain any questions' do
      specify { expect(presenter.questions).to eq([]) }
    end

    context 'when the subsection contains a list of questions' do
      let(:questions) { %i[ss_question_1 ss_question_2] }
      let(:subsections_questions) {
        { subsection_name.to_sym => questions }
      }

      before do
        allow(section).to receive(:subsections_questions).and_return(subsections_questions)
      end

      it 'returns a list of question presenters for the subsection questions' do
        expect(presenter.questions).to be_a(Array)
        expect(presenter.questions.size).to eq(questions.size)
        presenter.questions.each do |question|
          expect(question).to be_kind_of(Print::AssessmentQuestionPresenter)
        end
        expect(presenter.questions.map(&:name)).to match_array(questions)
      end
    end
  end

  describe '#relevant' do
    let(:questions) { %i[ss_question_1 ss_question_2] }
    let(:subsections_questions) {
      { subsection_name.to_sym => questions }
    }

    before do
      allow(section).to receive(:subsections_questions).and_return(subsections_questions)
    end

    context 'when there are no relevant answers' do
      before do
        allow_any_instance_of(Print::AssessmentQuestionPresenter).to receive(:answer_is_relevant?).and_return(false)
      end

      it 'returns No' do
        expect(presenter.relevant).to eq('No')
      end
    end

    context 'when there is at least one relevant answer' do
      before do
        allow_any_instance_of(Print::AssessmentQuestionPresenter).to receive(:answer_is_relevant?).and_return(true)
      end

      it 'returns highlighted Yes' do
        expect(presenter.relevant).to eq('<div class="strong-text">Yes</div>')
      end
    end
  end

  describe '#label' do
    before do
      localize_key("summary.section.titles.#{subsection_name}", 'Localised subsection name')
    end

    context 'when section is NOT relevant' do
      before do
        allow(presenter).to receive(:relevant?).and_return(false)
      end

      it 'returns the non highlighted label' do
        expect(presenter.label).to eq('Localised subsection name')
      end
    end

    context 'when section is relevant' do
      before do
        allow(presenter).to receive(:relevant?).and_return(true)
      end

      it 'returns the highlighted label' do
        expect(presenter.label).to eq('<div class="strong-text">Localised subsection name</div>')
      end
    end
  end
end
