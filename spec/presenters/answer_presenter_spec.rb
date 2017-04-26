require 'rails_helper'

RSpec.describe AnswerPresenter, type: :presenter do
  let(:data) { { value: 'some_value' } }
  let(:answer) { Schemas::Answer.new(data) }

  subject(:presenter) { described_class.new(answer) }

  describe '#questions' do
    context 'when the answer has no associated questions' do
      specify { expect(presenter.questions).to be_empty }
    end

    context 'when the answer has associated questions' do
      let(:data) {
        {
          value: 'answer_value',
          questions: [
            { name: 'question_1', type: 'string' },
            { name: 'question_2', type: 'boolean' }
          ]
        }
      }

      it 'returns a list of presentation objects for the questions' do
        expect(presenter.questions).not_to be_empty
        presenter.questions.each do |question|
          expect(question).to be_an_instance_of(QuestionPresenter)
        end
      end
    end
  end
end
