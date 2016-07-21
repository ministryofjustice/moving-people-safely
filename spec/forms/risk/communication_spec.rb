require 'rails_helper'

RSpec.describe Forms::Risk::Communication, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'interpreter_required' => 'yes',
      'language' => 'German',
      'hearing_speach_sight' => 'yes',
      'hearing_speach_sight_details' => 'Blind',
      'can_read_and_write' => 'yes',
      'can_read_and_write_details' => 'Can only read',
    }
  }

  describe '#validate' do
    it { is_expected.to validate_strict_string(:language) }

    context "for the 'interpreter_required' attribute" do
      it { is_expected.to validate_optional_field(:interpreter_required) }

      context 'when interpreter_required is set to yes' do
        before { subject.interpreter_required = 'yes' }
        it { is_expected.to validate_presence_of(:language) }
      end
    end

    it { is_expected.to validate_optional_details_field(:hearing_speach_sight) }
    it { is_expected.to validate_optional_details_field(:can_read_and_write) }
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
