require 'rails_helper'

RSpec.describe Print::AssessmentSectionPresenter do
  let(:name) { 'some_section' }
  let(:section) { instance_double(Assessments::Section, name: name) }
  let(:question) { double(Assessments::Question) }
  let(:question_presenter) { Print::AssessmentQuestionPresenter.new(question) }
  let(:questions) { [question_presenter] }

  subject(:presenter) { described_class.new(section) }

  describe '#relevant' do
    before do
      allow(presenter).to receive(:questions).and_return(questions)
    end

    context 'when there is no relevant questions for the section' do
      before do
        allow(question).to receive(:relevant_answer?).and_return(false)
      end

      it 'returns the non-highlighted No' do
        expect(presenter.relevant).to eq('No')
      end
    end

    context 'when there is at least one relevant question for the section' do
      before do
        allow(question).to receive(:relevant_answer?).and_return(true)
      end

      it 'returns the highlighted Yes' do
        expect(presenter.relevant).to eq('<div class="strong-text">Yes</div>')
      end
    end
  end

  describe '#label' do
    before do
      allow(presenter).to receive(:questions).and_return(questions)
      localize_key("print.section.titles.#{name}", 'Localised section name')
    end

    context 'when there is no relevant questions for the section' do
      before do
        allow(question).to receive(:relevant_answer?).and_return(false)
      end

      it 'returns the non-highlighted version of the label' do
        expect(presenter.label).to eq('Localised section name')
      end
    end

    context 'when there is at least one relevant question for the section' do
      before do
        allow(question).to receive(:relevant_answer?).and_return(true)
      end

      it 'returns the highlighted version of the label' do
        expect(presenter.label).to eq('<div class="strong-text">Localised section name</div>')
      end
    end
  end
end
