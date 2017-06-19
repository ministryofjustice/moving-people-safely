require 'rails_helper'

RSpec.describe Risk, type: :model do
  it { is_expected.to be_a(Questionable) }
  it { is_expected.to be_a(Reviewable) }

  it { is_expected.to belong_to(:escort) }

  subject { described_class.new }

  include_examples 'reviewable'
end
