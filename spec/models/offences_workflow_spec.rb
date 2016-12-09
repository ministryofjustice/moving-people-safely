require 'rails_helper'

RSpec.describe OffencesWorkflow do
  subject { described_class.new }
  specify { expect(subject.type).to eq('offences') }
  include_examples 'workflow'
end
