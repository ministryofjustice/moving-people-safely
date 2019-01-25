require 'rails_helper'

RSpec.describe Forms::Detainee, type: :form do
  let(:model) { Detainee.new(escort: escort) }

  subject { described_class.new(model) }

  let(:params) {
    {
      forenames: 'Jimmy',
      surname: 'Nail',
      gender: 'male',
      nationalities: 'British',
      religion: 'Baptist',
      ethnicity: 'European',
      date_of_birth: '30/12/1946',
      cro_number: 'SOMECRO',
      pnc_number: pnc_number,
      aliases: 'The Nailfile, Crocodile Shoes',
      prison_number: prison_number,
      image_filename: ''
    }.with_indifferent_access
  }

  describe '#validate' do
    context 'from prison' do
      let(:escort) { create(:escort, :from_prison)}
      let(:prison_number) { 'A1234Ab' }
      let(:pnc_number) { '' }

      describe 'nilifies empty strings' do
        %w[ forenames surname gender nationalities pnc_number
            cro_number aliases ].each do |attribute|
          it { is_expected.to validate_strict_string(attribute) }
        end
      end

      it 'coerces params' do
        subject.validate(params)
        expect(subject.prison_number).to eq prison_number.upcase
        expect(subject.date_of_birth).to eq Date.civil(1946, 12, 30)
      end

      it do
        is_expected.to validate_inclusion_of(:gender).
          in_array(Forms::Detainee::GENDERS)
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

      it { is_expected.to validate_presence_of(:surname).with_message('Enter a last name') }
      it { is_expected.to validate_presence_of(:forenames).with_message('Enter first name(s)') }
    end

    context 'from police' do
      let(:escort) { create(:escort, :from_police)}
      let(:prison_number) { nil }
      let(:pnc_number) { '12/3z' }

      it 'coerces params' do
        subject.validate(params)
        expect(subject.pnc_number).to eq '12/0000003Z'
      end
    end
  end

  describe '#save' do
    let(:escort) { create(:escort, :from_prison)}
    let(:prison_number) { 'A1234Ab' }
    let(:pnc_number) { '' }

    it 'applies the data to the model the form is initialised with' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
