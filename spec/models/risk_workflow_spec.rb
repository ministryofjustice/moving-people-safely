require 'rails_helper'

RSpec.describe RiskWorkflow do
  subject { described_class.new }
  specify { expect(subject.type).to eq('risk') }
  include_examples 'workflow'
end
