require 'rails_helper'

RSpec.describe Print::RiskPresenter, type: :presenter do
  let(:answer) { true }
  let(:conditional_answer) { 'yes' }
  let(:model) { double(Risk) }
  let(:section_name) { 'test_section' }
  let(:section_class) {
    Class.new(BaseSection) do
      def name
        'test_section'
      end

      def questions
        %w[question_1 question_2]
      end
    end
  }
  let(:section) { section_class.new }
  subject(:presenter) { described_class.new(model, section: section_name) }

  it { is_expected.to be_a Print::AssessmentSectionPresenter }
  it_behaves_like 'print assessment section presenter'
end
