require 'rails_helper'

RSpec.describe Assessments::Question do
  let(:answers) { [] }
  let(:schema) { double(Schemas::Question, name: 'question_name', subquestions: [], answers: answers) }
  let(:assessment) { double(:assessment, question_name: answer) }
  subject(:question) { described_class.new(assessment, schema) }

  describe '#answered?' do
    context 'when answer is nil' do
      let(:answer) { nil }
      specify { expect(question.answered?).to be_falsey }
    end

    context 'when answer is not present' do
      let(:answer) { '' }
      specify { expect(question.answered?).to be_falsey }
    end

    context 'when answer is present' do
      let(:answer) { 'value' }
      specify { expect(question.answered?).to be_truthy }
    end
  end

  describe '#relevant_answer?' do
    let(:answer) { 'no' }

    context 'when not answered' do
      before { allow(question).to receive(:answered?).and_return(false) }
      specify { expect(question.relevant_answer?).to be_falsey }
    end

    context 'when answered' do
      before { allow(question).to receive(:answered?).and_return(true) }

      context 'and the question has no set of possible answers' do
        let(:answers) { [] }

        specify { expect(question.relevant_answer?).to be_truthy }
      end

      context 'and the question has a set of possible answers' do
        let(:answer_schema) { double(Schemas::Answer, questions: []) }
        let(:answers) { [answer_schema] }

        before { allow(schema).to receive(:answer_for).with(answer).and_return(answer_schema) }

        context 'and the question does not have a schema for the provided answer' do
          before { allow(schema).to receive(:answer_for).with(answer).and_return(nil) }
          specify { expect(question.relevant_answer?).to be_falsey }
        end

        context 'and answer is relevant' do
          before { allow(answer_schema).to receive(:relevant?).and_return(true) }
          specify { expect(question.relevant_answer?).to be_truthy }
        end

        context 'and answer is not marked as relevant' do
          before { allow(answer_schema).to receive(:relevant?).and_return(false) }
          specify { expect(question.relevant_answer?).to be_falsey }
        end
      end
    end
  end
end
