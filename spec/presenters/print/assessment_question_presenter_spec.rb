require 'rails_helper'

RSpec.describe Print::AssessmentQuestionPresenter do
  let(:section_name) { 'some_section' }
  let(:section) { instance_double(Assessments::Section, name: section_name) }
  let(:question_name) { 'some_question' }
  let(:question_type) { 'string' }
  let(:question_hash) { { name: question_name, type: question_type } }
  let(:question) { Assessments::Question.new(assessment, question_schema, parent: section) }
  let(:question_schema) { Schemas::Question.new(question_hash) }
  let(:answer) { 'some_answer' }
  let(:assessment) { double(:assessment) }

  subject(:presenter) { described_class.new(question) }

  before do
    allow(assessment).to receive(question_name).and_return(answer)
    allow(section).to receive(:is_section?).and_return(true)
  end

  describe '#label' do
    before do
      allow(question).to receive(:relevant_answer?).and_return(false)
      localize_key("print.section.questions.#{section_name}.#{question_name}", 'Localised question')
    end

    context 'when the answer is relevant' do
      before do
        allow(question).to receive(:relevant_answer?).and_return(true)
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

      before do
        allow(question).to receive(:relevant_answer?).and_return(false)
      end

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
          allow(question).to receive(:relevant_answer?).and_return(true)
        end

        it 'returns the answer highlighted' do
          expect(presenter.answer).to eq '<div class="strong-text">Some other value</div>'
        end
      end
    end
  end

  describe '#details' do
    let(:answer_detail_1) { 'foo' }
    let(:answer_detail_2) { 'bar' }
    let(:question_schema) { Schemas::Question.new(hash) }

    before do
      allow(assessment).to receive(:question_detail_1).and_return(answer_detail_1)
      allow(assessment).to receive(:question_detail_2).and_return(answer_detail_2)
    end

    context 'when the question has no defined details' do
      let(:hash) {
        {
          name: question_name,
          type: 'string',
          answers: [
            { value: answer }
          ]
        }
      }

      specify { expect(presenter.details).to be_nil }
    end

    context 'when the question has defined details' do
      let(:answer_dependant_questions) {
        [
          { name: 'question_detail_1', type: 'string' },
          { name: 'question_detail_2', type: 'string' }
        ]
      }
      let(:hash) {
        {
          name: question_name,
          type: 'string',
          answers: [
            {
              value: answer,
              questions: answer_dependant_questions
            }
          ]
        }
      }

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
        let(:answer_dependant_questions) {
          [
            { name: 'localised_question_detail_1', type: 'string' },
            { name: 'question_detail_2', type: 'string' }
          ]
        }

        before do
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
