require 'rails_helper'

RSpec.describe Escort, type: :model do
  it { is_expected.to have_one(:detainee).dependent(:destroy) }
end
