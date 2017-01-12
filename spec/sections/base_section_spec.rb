require 'rails_helper'

RSpec.describe BaseSection do
  class TestBaseSection < BaseSection
    def initialize(options = {})
      @question_dependencies = options[:question_dependencies]
      @questions_details = options[:questions_details]
      @subsections_questions = options[:subsections_questions]
    end

    def question_dependencies
      @question_dependencies || super
    end

    def questions_details
      @questions_details || super
    end

    def subsections_questions
      @subsections_questions || super
    end
  end

  let(:section) { TestBaseSection.new(options) }
  let(:options) { {} }

  describe '#question_is_conditional?' do
    context 'when there is no question conditions' do
      let(:options) { {} }
      specify { expect(section.question_is_conditional?(:some_question)).to be_falsey }
    end

    context 'when there is some question conditions' do
      let(:options) {{ question_dependencies: { dependant: [:some_question] } }}
      specify { expect(section.question_is_conditional?(:some_question)).to be_truthy }
    end
  end

  describe '#question_condition' do
    context 'when there is no question conditions' do
      let(:options) { {} }
      specify { expect(section.question_condition(:some_question)).to eq(nil) }
    end

    context 'when there is some question conditions' do
      let(:options) {{ question_dependencies: { dependant: [:some_question] } }}
      specify { expect(section.question_condition(:some_question)).to eq(:dependant) }
    end
  end

  describe '#question_has_details?' do
    context 'when there is no question details' do
      let(:options) { {} }
      specify { expect(section.question_has_details?(:some_question)).to be_falsey }
    end

    context 'when there is some question details' do
      let(:options) {{ questions_details: { some_question: %i[detail_1 detail_2] }}}
      specify { expect(section.question_has_details?(:some_question)).to be_truthy }
    end
  end

  describe '#question_details' do
    context 'when there is no question details' do
      let(:options) { {} }
      specify { expect(section.question_details(:some_question)).to eq(nil) }
    end

    context 'when there is some question details' do
      let(:options) {{ questions_details: { some_question: %i[detail_1 detail_2] }}}
      specify { expect(section.question_details(:some_question)).to match_array(%i[detail_1 detail_2]) }
    end
  end

  describe '#subsections' do
    context 'when there is no sub sections' do
      let(:options) { {} }
      specify { expect(section.subsections).to eq([]) }
    end

    context 'when there is sub sections' do
      let(:options) {
        {
          subsections_questions: {
            sub_section_1: %i[question_1 question_2],
            sub_section_2: %i[question_3]
          }
        }
      }
      specify { expect(section.subsections).to match_array(%i[sub_section_1 sub_section_2]) }
    end
  end

  describe '#has_subsections?' do
    context 'when there is no sub sections' do
      let(:options) { {} }
      specify { expect(section.has_subsections?).to be_falsey }
    end

    context 'when there is sub sections' do
      let(:options) {
        {
          subsections_questions: {
            sub_section_1: %i[question_1 question_2],
            sub_section_2: %i[question_3]
          }
        }
      }
      specify { expect(section.has_subsections?).to be_truthy }
    end
  end

  describe '#questions_for_subsection' do
    context 'when there is no sub sections' do
      let(:options) { {} }
      specify { expect(section.questions_for_subsection(:some_section)).to eq([]) }
    end

    context 'when there is sub sections' do
      let(:options) {
        {
          subsections_questions: {
            sub_section_1: %i[question_1 question_2],
            sub_section_2: %i[question_3]
          }
        }
      }
      specify { expect(section.questions_for_subsection(:sub_section_1)).to match_array(%i[question_1 question_2]) }
    end
  end
end
