require 'rails_helper'

RSpec.describe Summary::RiskSubsectionPresenter, type: :presenter do
  let(:answer) { true }
  let(:conditional_answer) { 'yes' }
  let(:model) { double(Risk) }
  let(:section_name) { 'test_section' }
  let(:subsection_name) { 'test_subsection' }
  let(:section_class) {
    Class.new(BaseSection) do
    end
  }
  let(:section) { section_class.new }
  subject(:presenter) { described_class.new(model, section: section_name, subsection: subsection_name) }

  it_behaves_like 'assessment subsection presenter'
end
