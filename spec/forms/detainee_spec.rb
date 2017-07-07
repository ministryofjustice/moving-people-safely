require 'rails_helper'

RSpec.describe Forms::Detainee, type: :form do
  let(:model) { Detainee.new }
  subject { described_class.new(model) }

  let(:prison_number) { 'A1234Ab' }
  let(:params) {
    {
      forenames: 'Jimmy',
      surname: 'Nail',
      gender: 'male',
      nationalities: 'British',
      date_of_birth: '30/12/1946',
      cro_number: 'SOMECRO',
      pnc_number: 'SOMEPNC',
      aliases: 'The Nailfile, Crocodile Shoes',
      prison_number: prison_number,
      image_filename: ''
    }.with_indifferent_access
  }

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ forenames surname gender nationalities pnc_number
          cro_number aliases ].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    it 'coerces params' do
      subject.validate(params)
      coerced_params = params.merge(prison_number: prison_number.upcase, date_of_birth: Date.civil(1946, 12, 30))
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it do
      is_expected.to validate_inclusion_of(:gender).
        in_array(%w[ male female ])
    end

    context 'date_of_birth' do
      context 'with a valid date_of_birth' do
        it 'returns true' do
          params[:date_of_birth] = '12/01/2000'
          expect(subject.validate(params)).to be true
        end
      end

      context 'with an invalid date_of_birth' do
        it 'returns false' do
          params[:date_of_birth] = 'invalid'
          expect(subject.validate(params)).to be false
        end

        it 'sets an error on date_of_birth' do
          params[:date_of_birth] = 'invalid'
          subject.validate(params)
          expect(subject.errors).to include :date_of_birth
        end
      end
    end

    it { is_expected.to validate_presence_of(:surname).with_message('^Enter a surname') }
    it { is_expected.to validate_presence_of(:forenames).with_message('^Enter first name(s)') }
  end

  describe '#save' do
    it 'applies the data to the model the form is initialised with' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end

