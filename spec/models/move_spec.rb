require 'rails_helper'

RSpec.describe Move, type: :model do
  it { is_expected.to belong_to(:escort) }
  it { is_expected.to have_many(:destinations).dependent(:destroy) }
end
