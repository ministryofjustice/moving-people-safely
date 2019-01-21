require 'rails_helper'

RSpec.describe Forms::Search, type: :form do
  subject { described_class.new(prison_number: prison_number, pnc_number: pnc_number) }
  let(:prison_number) { nil }
  let(:pnc_number) { nil }

  describe '#validate' do
    context 'from prison' do
      let(:prison_number) { 'A1234BC' }

      it 'expects it to be in the format \A[a-z]\d{4}[a-z]{2}\z/' do
        is_expected.to allow_value('A1234BC').for(:prison_number)
        is_expected.not_to allow_value('not_a_prison_number').for(:prison_number)
      end
    end

    context 'from police' do
      it 'expects it to be in the format \d{2}\/d{1,7}[a-z]\z/' do
        is_expected.to allow_value('12/1A').for(:pnc_number)
        is_expected.to allow_value('12/1234567A').for(:pnc_number)
        is_expected.not_to allow_value('not_a_pnc_number').for(:pnc_number)
      end
    end
  end
end
