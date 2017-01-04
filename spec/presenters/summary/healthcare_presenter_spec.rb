require 'rails_helper'

RSpec.describe Summary::HealthcarePresenter, type: :presenter do
  let(:answer) { true }
  let(:conditional_answer) { 'yes' }
  let(:model) { double(Healthcare) }
  let(:section_name) { 'test_section' }
  let(:section_class) {
    Class.new(BaseSection) do
    end
  }
  let(:section) { section_class.new }
  subject(:presenter) { described_class.new(model, section: section_name) }

  it { is_expected.to be_a SummaryPresenter }
  it_behaves_like 'assessment section presenter'
end
