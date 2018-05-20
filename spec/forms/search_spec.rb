require 'rails_helper'

RSpec.describe Forms::Search, type: :form do
  let(:params) { { 'prison_number': 'A1234BC' } }

  describe '#validate' do
    it { is_expected.to validate_presence_of(:prison_number) }

    it 'expects it to be in the format \A[a-z]\d{4}[a-z]{2}\z/' do
      is_expected.to allow_value('A1234BC').for(:prison_number)
      is_expected.not_to allow_value('not_a_prison_number').for(:prison_number)
    end
  end
end
