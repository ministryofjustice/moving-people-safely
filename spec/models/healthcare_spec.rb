require 'rails_helper'

RSpec.describe Healthcare, type: :model do
  it { is_expected.to belong_to(:escort) }
end
