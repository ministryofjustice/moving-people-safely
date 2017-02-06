require 'rails_helper'

RSpec.describe DetaineePresenter, type: :presenter do
  let(:detainee) { FactoryGirl.build(:detainee) }
  subject { described_class.new detainee }

  describe '#short_gender' do
    context 'when male' do
      let(:detainee) { FactoryGirl.build(:detainee, gender: 'male') }
      its(:short_gender) { is_expected.to eq 'M' }
    end

    context 'when female' do
      let(:detainee) { FactoryGirl.build(:detainee, gender: 'female') }
      its(:short_gender) { is_expected.to eq 'F' }
    end
  end

  describe '#humanized_date_of_birth' do
    let(:detainee) { FactoryGirl.build(:detainee, date_of_birth: Date.civil(1946, 6, 14)) }
    its(:humanized_date_of_birth) { is_expected.to eq '14 Jun 1946' }
  end

  describe '#age' do
    let(:detainee) { FactoryGirl.build(:detainee, date_of_birth: 50.years.ago.to_date) }
    its(:age) { is_expected.to eq(detainee.age) }
  end
end
