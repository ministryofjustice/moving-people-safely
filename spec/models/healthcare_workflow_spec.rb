require 'rails_helper'

RSpec.describe HealthcareWorkflow do
  subject { described_class.new }
  specify { expect(subject.type).to eq('healthcare') }
  include_examples 'workflow'
end
