require 'rails_helper'

RSpec.describe Medication, type: :model do
  it { is_expected.to belong_to(:healthcare) }
end
