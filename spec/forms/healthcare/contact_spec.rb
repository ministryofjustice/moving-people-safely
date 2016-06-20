require 'rails_helper'

RSpec.describe Forms::Healthcare::Contact, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      clinician_name: 'Doctor Robert',
      contact_number: '079876543',
    }.with_indifferent_access
  }

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
