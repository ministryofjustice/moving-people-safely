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

  describe '#total_questions_with_relevant_answer' do
    it 'returns the number of questions answered with relevance' do
      assessment.question_1 = 'open'
      assessment.question_2 = default_relevant_value
      assessment.question_3 = 'standard'
      expect(assessment.total_questions_with_relevant_answer).to eq 2
    end
  end

  describe '#total_questions_without_relevance' do
    it 'returns the number of questions answered without relevance' do
      assessment.question_1 = 'no'
      assessment.question_2 = default_relevant_value
      assessment.question_3 = 'standard'
      expect(subject.total_questions_without_relevance).to eq 2
    end
  end

  describe '#total_questions_not_answered' do
    it 'returns the number of questions not answered' do
      assessment.question_1 = 'no'
      expect(subject.total_questions_not_answered).to eq 2
    end
  end

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

  describe '#no_questions_answered?' do
    context 'when no questions have been answered' do
      it 'returns true' do
        expect(subject.no_questions_answered?).to be_truthy
      end
    end

    context 'when a question have been answered' do
      it 'returns false' do
        assessment.question_1 = 'no'
        expect(subject.no_questions_answered?).to be_falsey
      end
    end
  end
end
