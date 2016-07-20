require 'rails_helper'

RSpec.describe Forms::Risk::SubstanceMisuse, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'drugs' => 'yes',
      'drugs_details' => 'Heroin use',
      'alcohol' => 'yes',
      'alcohol_details' => 'Lots of beer',
    }
  }

  describe 'defaults' do
    its(:drugs) { is_expected.to eq 'unknown' }
    its(:alcohol) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ drugs_details alcohol_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:drugs).
        in_array(%w[ yes no unknown ])
    end

    context 'when drugs is set to yes' do
      before { subject.drugs = 'yes' }
      it { is_expected.to validate_presence_of(:drugs_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:alcohol).
        in_array(%w[ yes no unknown ])
    end

    context 'when alcohol is set to yes' do
      before { subject.alcohol = 'yes' }
      it { is_expected.to validate_presence_of(:alcohol_details) }
    end
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
