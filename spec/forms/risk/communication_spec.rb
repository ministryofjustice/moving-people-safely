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

  describe 'defaults' do
    its(:hearing_speach_sight) { is_expected.to eq 'unknown' }
    its(:can_read_and_write) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ language hearing_speach_sight_details can_read_and_write_details ].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    context "for the 'interpreter_required' attribute" do
      it { is_expected.to validate_optional_field(:interpreter_required) }

      context 'when interpreter_required is set to yes' do
        before { subject.interpreter_required = 'yes' }
        it { is_expected.to validate_presence_of(:language) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:hearing_speach_sight).
        in_array(%w[ yes no unknown ])
    end

    context 'when hearing_speach_sight is set to yes' do
      before { subject.hearing_speach_sight = 'yes' }
      it { is_expected.to validate_presence_of(:hearing_speach_sight_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:can_read_and_write).
        in_array(%w[ yes no unknown ])
    end

    context 'when can_read_and_write is set to yes' do
      before { subject.can_read_and_write = 'yes' }
      it { is_expected.to validate_presence_of(:can_read_and_write_details) }
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
