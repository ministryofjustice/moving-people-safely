require 'rails_helper'

RSpec.describe Destination, type: :model do
  it { is_expected.to belong_to(:move) }
end
