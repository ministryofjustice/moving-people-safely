require 'rails_helper'

RSpec.describe AssessmentPresenter, type: :presenter do
  let(:sections) { {} }
  let(:schema) { Schemas::Assessment.new(sections) }
  let(:assessment) { double(:assessment, schema: schema) }
  let(:step) { 'some_step' }

  subject(:presenter) { described_class.new(assessment, step) }

  describe '#sections' do
    context 'when the assessment has no sections' do
      specify { expect(presenter.sections).to be_empty }
    end

    context 'when there is no assessment section for the provided step' do
      let(:sections) { { foo: 'bar' } }

      specify { expect(presenter.sections).to be_empty }
    end

    context 'when the assessment section for the provided step has no associated subsections' do
      let(:sections) { { sections: { step => {} } } }

      specify { expect(presenter.sections).to be_empty }
    end

    context 'when the assessment section for the provided step has associated subsections' do
      let(:sections) {
        {
          sections: {
            step => {
              sections: {
                section_1: {},
                section_2: {}
              }
            }
          }
        }
      }

      it 'returns a list of presentation objects for the subsections' do
        expect(presenter.sections).not_to be_empty
        presenter.sections.each do |section|
          expect(section).to be_an_instance_of(SectionPresenter)
        end
      end
    end
  end

  describe '#questions' do
    context 'when the assessment has no sections' do
      specify { expect(presenter.questions).to be_empty }
    end

    context 'when there is no assessment section for the provided step' do
      let(:sections) { { foo: 'bar' } }

      specify { expect(presenter.questions).to be_empty }
    end

    context 'when the assessment section for the provided step has no associated questions' do
      let(:sections) { { sections: { step => {} } } }

      specify { expect(presenter.questions).to be_empty }
    end

    context 'when the assessment section for the provided step has associated questions' do
      let(:sections) {
        {
          sections: {
            step => {
              questions: [
                { name: 'question_1', type: 'string' },
                { name: 'question_2', type: 'boolean' }
              ]
            }
          }
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