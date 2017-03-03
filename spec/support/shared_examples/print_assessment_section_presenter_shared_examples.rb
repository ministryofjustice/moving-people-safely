RSpec.shared_examples_for 'print assessment section presenter' do
  before do
    allow(presenter).to receive(:section).and_return(section)
    allow(model).to receive(:question).and_return(answer)
    allow(model).to receive(:conditional_question).and_return(conditional_answer)
  end

  describe '#questions' do
    it 'returns a list of question presenters for the section questions' do
      expect(presenter.questions).to be_a(Array)
      expect(presenter.questions.size).to eq(section.questions.size)
      presenter.questions.each do |question|
        expect(question).to be_kind_of(Print::AssessmentQuestionPresenter)
      end
      expect(presenter.questions.map(&:name)).to match_array(section.questions)
    end
  end

  describe '#relevant' do
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
      localize_key("summary.section.titles.#{section_name}", 'Localised section name')
    end

    context 'when section is NOT relevant' do
      before do
        allow(presenter).to receive(:relevant?).and_return(false)
      end

      it 'returns the non highlighted label' do
        expect(presenter.label).to eq('Localised section name')
      end
    end

    context 'when section is relevant' do
      before do
        allow(presenter).to receive(:relevant?).and_return(true)
      end

      it 'returns the highlighted label' do
        expect(presenter.label).to eq('<div class="strong-text">Localised section name</div>')
      end
    end
  end
end
