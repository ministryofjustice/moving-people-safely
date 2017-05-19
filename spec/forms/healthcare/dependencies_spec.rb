require 'rails_helper'

RSpec.describe Forms::Healthcare::Dependencies, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      dependencies: 'yes',
      dependencies_details: 'Drugs',
    }.with_indifferent_access
  }

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:dependencies) }
  end
end
