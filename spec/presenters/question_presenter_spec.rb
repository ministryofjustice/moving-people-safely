require 'rails_helper'

RSpec.describe QuestionPresenter do
  let(:question_type) { 'string' }
  let(:data) { { name: 'question_name', type: question_type } }
  let(:question) { Schemas::Question.new(data) }
  subject(:presenter) { described_class.new(question) }

  describe '#subquestions' do
    context 'when the question has no subquestions' do
      specify { expect(presenter.subquestions).to be_empty }
    end

    context 'when the question has associated subquestions' do
      let(:data) {
        {
          name: 'question_name',
          type: question_type,
          questions: [
            { name: 'subquestion_1', type: 'string' },
            { name: 'subquestion_2', type: 'boolean' }
          ]
        }
      }

      it 'returns a list of presentation objects for the questions' do
        expect(presenter.subquestions).not_to be_empty
        presenter.subquestions.each do |question|
          expect(question).to be_an_instance_of(QuestionPresenter)
        end
      end
    end
  end

  describe '#answers_options' do
    context 'when there are no answer options' do
      let(:data) { { name: 'question_name', type: question_type } }
      specify { expect(presenter.answers_options).to be_empty }
    end

    context 'when there are answer options' do
      let(:answers) {
        [
          { value: 'option_1' },
          { value: 'option_2' }
        ]
      }
      let(:data) { { name: 'question_name', type: question_type, answers: answers } }

      it 'returns a list of the values for all the possible answers' do
        expect(presenter.answers_options).to match_array(%w[option_1 option_2])
      end
    end
  end

  describe '#conditional_questions' do
    context 'when there are no answers options' do
      let(:data) { { name: 'question_name', type: question_type } }
      specify { expect(presenter.conditional_questions).to be_empty }
    end

    context 'when there are no answers requiring additional questions to be answered' do
      let(:answers) {
        [
          { value: 'option_1' },
          { value: 'option_2' }
        ]
      }
      let(:data) { { name: 'question_name', type: question_type, answers: answers } }
      specify { expect(presenter.conditional_questions).to be_empty }
    end

    context 'when there is at least one answer requiring additional questions to be answered' do
      let(:answers) {
        [
          { value: 'option_1', questions: [ { name: 'option_1_question', type: 'string' } ] },
          { value: 'option_2' }
        ]
      }
      let(:data) { { name: 'question_name', type: question_type, answers: answers } }

      it 'returns a list of all the additional questions that need to answered' do
        expect(presenter.conditional_questions.map(&:name)).to match_array(%w[option_1_question])
      end
    end
  end

  describe '#display_type' do
    context 'when the question type is group' do
      let(:question_type) { 'group' }
      specify { expect(presenter.display_type).to eq('fieldset') }
    end

    context 'when the question type is boolean' do
      let(:question_type) { 'boolean' }
      specify { expect(presenter.display_type).to eq('checkbox') }
    end

    context 'when the question type is date' do
      let(:question_type) { 'date' }
      specify { expect(presenter.display_type).to eq('text_field') }
    end

    context 'when the question type is string' do
      let(:question_type) { 'string' }

      context 'and there are answer options' do
        let(:answers) {
          [
            { value: 'option_1' },
            { value: 'option_2' }
          ]
        }
        let(:data) { { name: 'question_name', type: question_type, answers: answers } }
        specify { expect(presenter.display_type).to eq('radio_button') }
      end

      context 'and the question is a detail field' do
        let(:data) { { name: 'question_name_details', type: question_type } }
        specify { expect(presenter.display_type).to eq('text_area') }
      end

      context 'and the question just requires a value to be inputted manually' do
        let(:data) { { name: 'question_name', type: question_type } }
        specify { expect(presenter.display_type).to eq('text_field') }
      end
    end

    context 'when the question type is something not supported' do
      let(:question_type) { 'not-a-valid-type' }
      specify { expect(presenter.display_type).to be_nil }
    end
  end

  describe '#display_inline?' do
    context 'when the question has no answer options' do
      let(:data) { { name: 'question_name', type: question_type } }
      specify { expect(presenter.display_inline?).to be_falsey }
    end

    context 'when none of the answer options are the value unknown' do
      let(:answers) {
        [
          { value: 'option_1' },
          { value: 'option_2' }
        ]
      }
      let(:data) { { name: 'question_name', type: question_type, answers: answers } }
      specify { expect(presenter.display_inline?).to be_falsey }
    end

    context 'when one of the answer options has the value unknown' do
      let(:answers) {
        [
          { value: 'option_1' },
          { value: 'unknown' }
        ]
      }
      let(:data) { { name: 'question_name', type: question_type, answers: answers } }
      specify { expect(presenter.display_inline?).to be_truthy }
    end
  end

  describe '#toggle_field' do
    context 'when there are no answer options' do
      let(:data) { { name: 'question_name', type: question_type } }
      specify { expect(presenter.toggle_field).to be_nil }
    end

    context 'when none of the answer options has additional questions to answer' do
      let(:answers) {
        [
          { value: 'option_1' },
          { value: 'option_2' }
        ]
      }
      let(:data) { { name: 'question_name', type: question_type, answers: answers } }
      specify { expect(presenter.toggle_field).to be_nil }
    end

    context 'when at least one of the answer options has additional questions to answer' do
      let(:answers) {
        [
          { value: 'option_1', questions: [ { name: 'option_1_question', type: 'string' } ] },
          { value: 'option_2', questions: [ { name: 'option_2_question', type: 'string' } ] },
          { value: 'unknown' }
        ]
      }
      let(:data) { { name: 'question_name', type: question_type, answers: answers } }

      it 'returns the first answer value with additional questions to answer' do
        expect(presenter.toggle_field).to eq('option_1')
      end
    end
  end
end
