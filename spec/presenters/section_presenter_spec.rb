require 'rails_helper'

RSpec.describe SectionPresenter, type: :presenter do
  let(:name) { 'some_section' }
  let(:data) { {} }
  let(:section) { Schemas::Section.new(name, data) }

  subject(:presenter) { described_class.new(section) }

  describe '#subsections' do
    context 'when the section has no subsections' do
      specify { expect(presenter.subsections).to be_empty }
    end

    context 'when the section has associated subsections' do
      let(:data) {
        {
          sections: {
            section_1: {},
            section_2: {}
          }
        }
      }

      it 'returns a list of presentation objects for the subsections' do
        expect(presenter.subsections).not_to be_empty
        presenter.subsections.each do |section|
          expect(section).to be_an_instance_of(SectionPresenter)
        end
      end
    end
  end

  describe '#questions' do
    context 'when the section has no subsections' do
      specify { expect(presenter.questions).to be_empty }
    end

    context 'when the section section for the provided step has associated questions' do
      let(:data) {
        {
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
