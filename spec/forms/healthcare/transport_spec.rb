require 'rails_helper'

RSpec.describe Forms::Healthcare::Transport, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      mpv: 'yes',
      mpv_details: 'Needs an MPV',
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:mpv) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ mpv_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:mpv).
        in_array(%w[ yes no unknown ])
    end

    context 'when mpv is set to yes' do
      before { subject.mpv = 'yes' }
      it { is_expected.to validate_presence_of(:mpv_details) }
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
