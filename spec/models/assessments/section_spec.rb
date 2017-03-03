require 'rails_helper'

RSpec.describe Assessments::Section do
  let(:name) { 'some_section' }
  let(:questions) { [] }
  let(:subsections) { {} }
  let(:data) {
    {
      questions: questions,
      subsections: subsections
    }
  }
  subject { described_class.new(name, data) }

  describe '#has_subsections?' do
    context 'when there are subsections' do
      let(:subsections) { { other_section: { questions: []}} }
      specify { expect(subject.has_subsections?).to be_truthy }
    end

    context 'when there are no subsections' do
      let(:subsections) { {} }
      specify { expect(subject.has_subsections?).to be_falsey }
    end
  end

  describe '#subsections' do
    let(:subsections) { { other_section: { questions: []}} }

    specify {
      subject.subsections.each do |subsection|
        expect(subsection).to be_kind_of(described_class)
      end
    }
  end

  describe '#questions' do
    let(:questions) { [{ name: 'question_name' }] }

    specify {
      subject.questions.each do |question|
        expect(question).to be_kind_of(Assessments::Question)
      end
    }
  end
end

