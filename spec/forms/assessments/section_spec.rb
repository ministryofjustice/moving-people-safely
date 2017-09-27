require 'rails_helper'

RSpec.describe Forms::Assessments::Section do
  class TestClassForAssessmentSection
    include ActiveModel::Validations

    def save
      'success!'
    end
  end
  let(:assessment) { TestClassForAssessmentSection.new }
  let(:hash) { { questions: [] } }
  let(:section) { Schemas::Section.new('section_name', hash) }
  let(:params) { {} }
  subject(:form) { described_class.new(assessment, section, params) }

  describe '#name' do
    it 'returns the section name' do
      expect(form.name).to eq('section_name')
    end
  end

  describe '#scope' do
    context 'when it has a parent' do
      let(:parent) { double(:parent, scope: 'parent-scope') }
      subject(:form) { described_class.new(assessment, section, params, parent: parent) }

      it 'returns the parent scope' do
        expect(form.scope).to eq('parent-scope')
      end
    end

    context 'when it does not have a parent' do
      subject(:form) { described_class.new(assessment, section, params) }

      it 'returns the section name' do
        expect(form.scope).to eq('section_name')
      end
    end
  end

  describe '#requires_dependencies?' do
    specify { expect(form.requires_dependencies?).to be_truthy }
  end

  describe '#valid?' do
    context 'when there are no answers to validate' do
      let(:hash) { { questions: [] } }
      specify { expect(form).to be_valid }
    end

    context 'when there are answers to validate' do
      let(:hash) {
        {
          questions: [
            { name: 'question_1', type: 'string' },
            { name: 'question_2', type: 'boolean' }
          ]
        }
      }

      context 'and at least one of the answers is not valid' do
        let(:valid_answer) { instance_double(Forms::Assessments::Answer, valid?: true, errors: []) }
        let(:invalid_answer) { instance_double(Forms::Assessments::Answer, valid?: false, errors: []) }

        before do
          expect(Forms::Assessments::Answer)
            .to receive(:new).twice.and_return(valid_answer, invalid_answer)
        end

        specify { expect(form).not_to be_valid }
      end

      context 'and all the answers are valid' do
        let(:valid_answer) { instance_double(Forms::Assessments::Answer, valid?: true, errors: []) }

        before do
          expect(Forms::Assessments::Answer)
            .to receive(:new).twice.and_return(valid_answer)
        end

        specify { expect(form).to be_valid }
      end
    end
  end

  describe '#reset' do
    let(:hash) {
      {
        questions: [
          { name: 'question_1', type: 'string' },
          { name: 'question_2', type: 'boolean' }
        ]
      }
    }
    let(:stub_answer) { instance_double(Forms::Assessments::Answer, reset: true) }

    it 'resets all the top level answers' do
      expect(Forms::Assessments::Answer).to receive(:new).exactly(2).times.and_return(stub_answer)
      expect(stub_answer).to receive(:reset).exactly(2).times.and_return(true)
      form.reset
    end
  end

  describe '#save' do
    it 'resets the form before saving clearing any unusued values' do
      expect(form).to receive(:reset)
      expect(form.save).to eq('success!')
    end
  end
end
