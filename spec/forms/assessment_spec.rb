require 'rails_helper'

RSpec.describe Forms::Assessment do
  class TestClassForFormsAssessment
    attr_accessor :schema, :question_1

    def initialize(options)
      @schema = options.fetch(:schema)
    end
  end

  describe '.for_section' do
    let(:section_name) { 'some_section' }
    let(:hash) {
      {
        sections: {
          section_name => {
            questions: [
              { name: 'question_1', type: 'string' }
            ]
          }
        }
      }
    }
    let(:schema) { Schemas::Assessment.new(hash) }
    let(:assessment) { TestClassForFormsAssessment.new(schema: schema) }
    let(:params) { {} }

    it 'returns a new form instance for the requested section' do
      form = described_class.for_section(assessment, section_name, params)
      expect(form).to be_an_instance_of(Forms::Assessments::Section)
      expect(form.name).to eq(section_name)
    end

    context 'when there is no schema for the provided section name' do
      let(:hash) {
        {
          sections: {
            some_other_section: {
              questions: [
                { name: 'question_1', type: 'string' }
              ]
            }
          }
        }
      }

      it 'returns nil' do
        form = described_class.for_section(assessment, section_name, params)
        expect(form).to be_nil
      end
    end
  end
end
