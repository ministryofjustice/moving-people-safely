require 'rails_helper'

RSpec.describe Forms::CurrentOffence, type: :form do
  subject { described_class.new(model) }

  # FIXME: save spec explodes, we don't really need to test this as reform owns it
  let(:model) { CurrentOffence.new(offences: Offences.new) }

  let(:form_data) do
    {
      'offence' => 'Burglary',
      'case_reference' => 'T123456'
    }
  end

  describe "#validate" do
    it { is_expected.to validate_presence_of(:offence) }
    it { is_expected.to validate_presence_of(:case_reference) }
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(form_data)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
