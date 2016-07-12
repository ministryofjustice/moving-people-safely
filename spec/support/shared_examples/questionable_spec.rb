require 'spec_helper'

shared_examples_for "questionable" do
  let(:model) { described_class.new }

  describe '#questions_answered_yes' do
    it 'returns the number of questions answered yes' do
      model.send("#{model.question_fields.sample}=", 'yes')
      expect(model.questions_answered_yes).to eq 1
    end
  end

  describe '#questions_answered_no' do
    it 'returns the number of questions answered no' do
      model.send("#{model.question_fields.sample}=", 'no')
      expect(model.questions_answered_no).to eq 1
    end
  end

  describe '#questions_not_answered' do
    it 'returns the number of questions not answered' do
      expect(model.questions_not_answered).to eq model.question_fields.size
    end
  end

  describe '#all_questions_answered?' do
    context 'when all questions have been answered' do
      it 'returns true' do
        model.question_fields.each { |q| model.send("#{q}=", 'yes') }
        expect(model.all_questions_answered?).to be true
      end
    end

    context 'when not all questions have been answered' do
      it 'returns false' do
        model.send("#{model.question_fields.sample}=", 'no')
        expect(model.all_questions_answered?).to be false
      end
    end
  end

  describe '#no_questions_answered?' do
    context 'when no questions have been answered' do
      it 'returns true' do
        expect(model.no_questions_answered?).to be true
      end
    end

    context 'when a question have been answered' do
      it 'returns false' do
        model.send("#{model.question_fields.sample}=", 'no')
        expect(model.no_questions_answered?).to be false
      end
    end
  end
end
