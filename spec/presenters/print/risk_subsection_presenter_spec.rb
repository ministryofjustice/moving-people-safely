require 'rails_helper'

RSpec.describe Print::RiskSubsectionPresenter, type: :presenter do
  let(:answer) { true }
  let(:conditional_answer) { 'yes' }
  let(:model) { double(Risk) }
  let(:section_name) { 'test_section' }
  let(:subsection_name) { 'test_subsection' }
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
  subject(:presenter) { described_class.new(model, section: section_name, subsection: subsection_name) }

  it_behaves_like 'print assessment subsection presenter'
end
