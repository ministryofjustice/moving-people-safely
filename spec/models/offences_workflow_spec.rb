require 'rails_helper'

RSpec.describe OffencesWorkflow, type: :model do
  it { is_expected.to be_a(Reviewable) }

  it { is_expected.to belong_to(:detainee) }

  subject { described_class.new }

  include_examples 'reviewable'
end
