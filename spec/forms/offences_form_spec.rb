require 'rails_helper'

RSpec.describe OffencesForm, type: :form do
  subject { described_class.new(Offences.new) }

  let(:form_data) do
    {
      'release_date' => '15/09/2027',
      'not_for_release' => 'yes',
      'not_for_release_reason' => 'remember what happened last time?'
    }
  end

  describe "#validate" do
    let(:coerced_params) do
      {
        'release_date' => Date.new(2027, 9, 15),
        'not_for_release' => true,
        'not_for_release_reason' => 'remember what happened last time?'
      }
    end

    it 'coerces params' do
      subject.validate(form_data)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it { is_expected.to validate_presence_of(:release_date) }
    it { is_expected.to validate_string_as_date(:release_date) }
  end
end
