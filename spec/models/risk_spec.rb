require 'rails_helper'

RSpec.describe Risk, type: :model do
  it { is_expected.to belong_to(:detainee) }
  it_behaves_like 'questionable'
end
