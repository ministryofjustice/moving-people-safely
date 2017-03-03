require 'rails_helper'

RSpec.describe Assessments::Question do
  let(:name) { 'question_name' }
  let(:data) { { name: name } }

  subject { described_class.new(data) }

  describe '#has_dependencies?' do
    context 'when there are no dependencies' do
      let(:dependencies) { [] }
      let(:data) { { name: name, dependencies: dependencies } }

      specify { expect(subject.has_dependencies?).to be_falsey }
    end

    context 'when there are dependencies' do
      let(:dependencies) { %w[dependency_question] }
      let(:data) { { name: name, dependencies: dependencies } }

      specify { expect(subject.has_dependencies?).to be_truthy }
    end
  end

  describe '#relevant_answer?' do
    context 'when relevant answers is empty' do
      let(:relevant_answers) { [] }
      let(:data) { { name: name, relevant_answers: relevant_answers } }

      specify { expect(subject.relevant_answer?('answer')).to be_falsey }
    end

    context 'when provided answer is blank' do
      let(:relevant_answers) { %w[some answer] }
      let(:data) { { name: name, relevant_answers: relevant_answers } }

      specify { expect(subject.relevant_answer?('')).to be_falsey }
    end

    context 'when relevant answers is :all' do
      let(:relevant_answers) { :all }
      let(:data) { { name: name, relevant_answers: relevant_answers } }

      specify { expect(subject.relevant_answer?('answer')).to be_truthy }
    end

    context 'when answer is not one of the relevant answers' do
      let(:relevant_answers) { ['some other answer'] }
      let(:data) { { name: name, relevant_answers: relevant_answers } }

      specify { expect(subject.relevant_answer?('answer')).to be_falsey }
    end

    context 'when answer is one of the relevant answers' do
      let(:relevant_answers) { ['some other answer', 'the answer'] }
      let(:data) { { name: name, relevant_answers: relevant_answers } }

      specify { expect(subject.relevant_answer?('the answer')).to be_truthy }
    end
  end

  describe '#has_details?' do
    context 'when there are no details' do
      let(:details) { [] }
      let(:data) { { name: name, details: details } }

      specify { expect(subject.has_details?).to be_falsey }
    end

    context 'when there are details' do
      let(:details) { %w[question_details] }
      let(:data) { { name: name, details: details } }

      specify { expect(subject.has_details?).to be_truthy }
    end
  end
end
