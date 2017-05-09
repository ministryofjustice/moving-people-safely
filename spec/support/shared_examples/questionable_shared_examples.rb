require 'spec_helper'

RSpec.shared_examples_for "questionable" do
  let(:model) { described_class.new }

  def assign_value(attr, value)
    model.send("#{attr}=", value)
  end

  describe '#total_questions_with_relevant_answer' do
    it 'returns the number of questions answered with relevance' do
      attr = model.mandatory_questions.sample.name
      assign_value(attr, 'yes')
      expect(model.total_questions_with_relevant_answer).to eq 1
    end
  end

  describe '#total_questions_without_relevance' do
    it 'returns the number of questions answered without relevance' do
      attr = model.mandatory_questions.sample.name
      assign_value(attr, 'no')
      expect(model.total_questions_without_relevance).to eq 1
    end
  end

  describe '#total_questions_not_answered' do
    it 'returns the number of questions not answered' do
      expect(model.total_questions_not_answered).to eq model.mandatory_questions.size
    end
  end

  describe '#all_questions_answered?' do
    context 'when all questions have been answered' do
      it 'returns true' do
        model.mandatory_questions.each { |question| assign_value(question.name, 'yes') }
        expect(model.all_questions_answered?).to be_truthy
      end
    end

    context 'when not all questions have been answered' do
      it 'returns false' do
        attr = model.mandatory_questions.sample.name
        assign_value(attr, 'no')
        expect(model.all_questions_answered?).to be_falsey
      end
    end
  end

  describe '#no_questions_answered?' do
    context 'when no questions have been answered' do
      it 'returns true' do
        expect(model.no_questions_answered?).to be_truthy
      end
    end

    context 'when a question have been answered' do
      it 'returns false' do
        attr = model.mandatory_questions.sample.name
        assign_value(attr, 'no')
        expect(model.no_questions_answered?).to be_falsey
      end
    end
  end
end
