require 'rails_helper'

RSpec.describe MoveWorkflow do
  subject { described_class.new }
  specify { expect(subject.type).to eq('move') }
  include_examples 'workflow'
end
