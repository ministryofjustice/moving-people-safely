require 'rails_helper'

RSpec.describe Questionable do
  class TestQuestionableModule
    include Questionable

    attr_accessor :question_1, :question_2, :question_3
  end

  let(:default_relevant_value) { 'yes' }
  let(:hash) {
    {
      sections: {
        some_section: {
          questions: [
            { name: 'question_1', type: 'string', answers: [{ value: 'open', relevant: true }]},
            { name: 'question_2', type: 'string', answers: [{ value: 'yes'}]},
            { name: 'question_3', type: 'string', answers: [{ value: 'standard' }] }
          ]
        }
      }
    }
  }
  let(:schema) { Schemas::Assessment.new(hash) }

  subject(:assessment) { TestQuestionableModule.new }

  before { allow(assessment).to receive(:schema).and_return(schema) }

  describe '#all_questions_answered?' do
    context 'when all questions have been answered' do
      it 'returns true' do
        assessment.question_1 = default_relevant_value
        assessment.question_2 = 'no'
        assessment.question_3 = default_relevant_value
        expect(subject.all_questions_answered?).to be_truthy
      end
    end

    context 'when not all questions have been answered' do
      it 'returns false' do
        assessment.question_1 = 'no'
        expect(subject.all_questions_answered?).to be_falsey
      end
    end
  end

  describe '#any_questions_answered?' do
    context 'when some questions have been answered' do
      it 'returns true' do
        assessment.question_2 = default_relevant_value
        expect(subject.any_questions_answered?).to be_truthy
      end
    end

    context 'when no questions have been answered' do
      it 'returns false' do
        expect(subject.any_questions_answered?).to be_falsey
      end
    end
  end
end
