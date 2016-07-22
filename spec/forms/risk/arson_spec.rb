require 'rails_helper'

RSpec.describe Forms::Risk::Arson, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'arson' => 'yes',
      'arson_value' => 'high',
      'arson_details' => 'Burnt entire forests',
      'damage_to_property' => 'yes',
      'damage_to_property_details' => 'Several garages',
    }
  }

  describe 'defaults' do
    its(:arson) { is_expected.to eq 'unknown' }
    its(:damage_to_property) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ arson_details damage_to_property_details ].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:arson).
        in_array(%w[ yes no unknown ])
    end

    context 'when arson is set to yes' do
      before { subject.arson = 'yes' }
      it { is_expected.to validate_presence_of(:arson_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:damage_to_property).
        in_array(%w[ yes no unknown ])
    end

    context 'when damage_to_property is set to yes' do
      before { subject.damage_to_property = 'yes' }
      it { is_expected.to validate_presence_of(:damage_to_property_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:arson_value).
        in_array(%w[ high medium low ])
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
