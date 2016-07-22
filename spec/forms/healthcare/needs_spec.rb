require 'rails_helper'

RSpec.describe Forms::Healthcare::Needs, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      dependencies: 'yes',
      dependencies_details: 'Drugs',
      has_medications: 'yes',
      medications: [
        {
          description: 'Aspirin',
          administration: 'Once a day',
          carrier: 'detainee',
          _delete: '0'
        },
        {
          description: 'Ibrufen',
          administration: 'Weekly',
          carrier: 'detainee',
          _delete: '0'
        }
      ]
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:dependencies) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    it { is_expected.to validate_prepopulated_collection :medications }
    it { is_expected.to validate_optional_field(:has_medications) }

    describe 'nilifies empty strings' do
      %w[ dependencies_details ].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:dependencies).
        in_array(%w[ yes no unknown ])
    end

    context 'when dependencies is set to yes' do
      before { subject.dependencies = 'yes' }
      it { is_expected.to validate_presence_of(:dependencies_details) }
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes_without_nested_forms = subject.to_nested_hash.except(:medications)
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes_without_nested_forms
    end

    it 'sets the data on nested models' do
      subject.validate(params)
      subject.save

      model_medications = subject.model.medications.map(&:attributes)
      form_medications = medications_without_virtual_attributes(subject)

      model_medications.each_with_index do |md, index|
        expect(md).to include form_medications[index]
      end
    end

    def medications_without_virtual_attributes(form)
      form.to_nested_hash[:medications].each { |d| d.delete(:_delete) }
    end

    context 'removing medications' do
      let(:params_with_medication_marked_for_delete) {
        {
          dependencies: 'yes',
          dependencies_details: 'Drugs',
          has_medications: 'yes',
          medications: [
            description: 'Aspirin',
            administration: 'Once a day',
            carrier: 'Detainee',
            _delete: '1'
          ]
        }.with_indifferent_access
      }

      it 'doesnt pass the medication object to the model for saving' do
        subject.validate(params_with_medication_marked_for_delete)
        subject.save

        expect(subject.model.medications).to be_empty
      end

      context 'when medications not set to yes' do
        it 'doesnt save the medication objects' do
          %w[ no unknown ].each do |medication_value|
            params[:has_medications] = medication_value
            subject.validate(params)
            subject.save

            expect(subject.model.medications).to be_empty
          end
        end
      end
    end
  end

  describe '#add_medication' do
    it 'adds a new medication to the collection' do
      expect { subject.add_medication }.
        to change { subject.medications.size }.by(1)
    end
  end
end
