require 'rails_helper'

RSpec.describe Forms::Healthcare::StepManager, type: :form do
  let(:escort) { Escort.create }
  let(:step_name) { 'physical' }

  describe '.build_step_for' do
    subject { described_class.build_step_for(step_name, escort) }

    its(:name)          { is_expected.to eq step_name }
    its(:node_position) { is_expected.to be 1 }
    its(:form)          { is_expected.to be_a Forms::Healthcare::Physical }
    its(:path)          { is_expected.to eq "/#{escort.id}/physical" }
    its(:has_next?)     { is_expected.to be true }
    its(:next_path)     { is_expected.to eq "/#{escort.id}/mental" }
    its(:has_prev?)     { is_expected.to be false }
    its(:prev_path)     { is_expected.to eq "/#{escort.id}/profile" }
  end

  describe '.total_steps' do
    it 'returns the total number of steps' do
      expect(described_class.total_steps).to eq 7
    end
  end
end
