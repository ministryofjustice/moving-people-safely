require 'rails_helper'

RSpec.describe Forms::Feedback, type: :form do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:message) }
  it { is_expected.to allow_value("email@addresse.foo").for(:email) }
  it { is_expected.to_not allow_value("bad.email").for(:email) }
end
