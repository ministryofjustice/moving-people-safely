require 'rails_helper'

RSpec.describe Move, type: :model do
  it { is_expected.to belong_to(:escort) }
end

