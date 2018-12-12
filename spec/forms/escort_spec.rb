require 'rails_helper'

RSpec.describe Forms::Escort, type: :form do
  let(:model) { Escort.new }
  subject(:form) { described_class.new }

  it { is_expected.to validate_presence_of(:cancelling_reason) }
end
