require 'rails_helper'

RSpec.describe Print::AssessmentQuestionPresenter do
  let(:section_name) { 'some_section' }
  let(:section) { Assessments::Section.new(section_name) }
  let(:question_name) { 'some_question' }
  let(:question) { Assessments::Question.new(name: question_name, section: section) }
  let(:answer) { 'some_answer' }
  let(:assessment) { double(:assessment) }

  subject(:presenter) { described_class.new(question, assessment) }

  before do
    allow(assessment).to receive(question_name).and_return(answer)
  end

  describe '#label' do
    before do
      allow(presenter).to receive(:answer_is_relevant?).and_return(false)
      localize_key("print.section.questions.#{section_name}.#{question_name}", 'Localised question')
    end

    context 'when the answer is relevant' do
      before do
        allow(presenter).to receive(:answer_is_relevant?).and_return(true)
      end

      it 'returns the highlighted label' do
        expect(presenter.label).to eq('<div class="strong-text">Localised question</div>')
      end
    end

    it 'returns the normal non-highlighted label' do
      expect(presenter.label).to eq('<div class="title">Localised question</div>')
    end
  end

  describe '#answer' do
    context 'and the question is answered no' do
      let(:answer) { 'no' }

      it 'returns the No content' do
        expect(presenter.answer).to eq 'No'
      end
    end

    context 'and the question is answered false' do
      let(:answer) { false }

      it 'returns the No content' do
        expect(presenter.answer).to eq 'No'
      end
    end

    context 'and the question is answered yes' do
      let(:answer) { 'yes' }

      it 'returns the Yes content' do
        expect(presenter.answer).to eq '<div class="strong-text">Yes</div>'
      end
    end

    context 'and the question is answered true' do
      let(:answer) { true }

      it 'returns the Yes content' do
        expect(presenter.answer).to eq '<div class="strong-text">Yes</div>'
      end
    end

    context 'and the question is answered with some other value' do
      let(:answer) { 'some_other_value' }

      context 'and the answer has a locale for the print page' do
        let(:answer) { 'some_localised_value' }

        before do
          localize_key("print.section.answers.#{section_name}.some_localised_value", 'Localised some other value')
        end

        it 'returns the localised version of the answer' do
          expect(presenter.answer).to eq('Localised some other value')
        end
      end

      context 'and the answer has no locale for the print page' do
        it 'returns the humanized version of it' do
          expect(presenter.answer).to eq 'Some other value'
        end
      end

      context 'and the answer is considered relevant' do
        before do
          allow(question).to receive(:relevant_answer?).with(answer).and_return(true)
        end

        it 'returns the answer highlighted' do
          expect(presenter.answer).to eq '<div class="strong-text">Some other value</div>'
        end
      end
    end
  end

  describe '#answer_is_relevant?' do
    context 'and the question is answered no' do
      let(:answer) { 'no' }

      specify { expect(presenter.answer_is_relevant?).to be_falsey }
    end

    context 'and the question is answered false' do
      let(:answer) { false }

      specify { expect(presenter.answer_is_relevant?).to be_falsey }
    end

    context 'and the question is answered yes' do
      let(:answer) { 'yes' }

      specify { expect(presenter.answer_is_relevant?).to be_truthy }
    end

    context 'and the question is answered true' do
      let(:answer) { true }

      specify { expect(presenter.answer_is_relevant?).to be_truthy }
    end

    context 'and the question is answered with some other value' do
      let(:answer) { 'some_other_value' }

      specify { expect(presenter.answer_is_relevant?).to be_falsey }

      context 'and the answer is considered relevant' do
        before do
          allow(question).to receive(:relevant_answer?).with(answer).and_return(true)
        end

        specify { expect(presenter.answer_is_relevant?).to be_truthy }
      end
    end
  end

  describe '#details' do
    let(:answer_detail_1) { 'foo' }
    let(:answer_detail_2) { 'bar' }

    before do
      allow(assessment).to receive(:question_detail_1).and_return(answer_detail_1)
      allow(assessment).to receive(:question_detail_2).and_return(answer_detail_2)
    end

    context 'when the question has no defined details' do
      before do
        allow(question).to receive(:details).and_return([])
      end
    end

    context 'when the question has defined details' do
      before do
        allow(question).to receive(:details).and_return(%w[question_detail_1 question_detail_2])
      end

      it 'returns a string with the combined details for the question' do
        expect(presenter.details).to eq('Foo. Bar')
      end

      context 'when one of the details is empty' do
        let(:answer_detail_1) { nil }

        it 'returns a string only with the details that are present' do
          expect(presenter.details).to eq('Bar')
        end
      end

      context 'when one of the details has a locale for its label in the print page' do
        before do
          allow(question).to receive(:details).and_return(%w[localised_question_detail_1 question_detail_2])
          allow(assessment).to receive(:localised_question_detail_1).and_return(answer_detail_1)
          localize_key("print.section.questions.#{section_name}.localised_question_detail_1", 'Localised question detail 1: ')
        end

        it 'prepends the localised label for the specified detail in the returned string' do
          expect(presenter.details).to eq('Localised question detail 1: Foo. Bar')
        end
      end

      context 'when one of the details has a localised version for the print page' do
        let(:answer_detail_2) { 'localised_answer_detail_2' }

        before do
          localize_key("print.section.answers.#{section_name}.localised_answer_detail_2", 'Localised answer detail 2')
        end

        it 'prepends the localised label for the specified detail in the returned string' do
          expect(presenter.details).to eq('Foo. Localised answer detail 2')
        end
      end
    end
  end
end
