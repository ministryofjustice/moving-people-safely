require 'rails_helper'

RSpec.describe Healthcare, type: :model do
  it { is_expected.to belong_to(:escort) }
  it { is_expected.to have_many(:medications).dependent(:destroy) }
  it_behaves_like 'questionable'
end
