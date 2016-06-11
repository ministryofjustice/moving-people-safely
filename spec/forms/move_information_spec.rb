require 'rails_helper'

RSpec.describe Forms::MoveInformation, type: :form do
  let(:model) { Move.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      from: 'Bedford',
      to: 'Albany',
      date: '1/2/2017',
      reason: 'sentencing',
      has_destinations: 'yes',
      destinations: [
        establishment: 'Hospital',
        must_return: 'must_return',
        reasons: 'Violence',
        _delete: '0'
      ]
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:from) { is_expected.to eq 'HMP Bedford' }
    its(:has_destinations) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ from to reason ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it 'coerces params' do
      coerced_params = params.merge(
        date: Date.civil(2017, 2, 1),
        destinations: [
          establishment: 'Hospital',
          must_return: 'must_return',
          reasons: 'Violence',
          _delete: false
        ]
      )

      subject.validate(params)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it do
      is_expected.
        to validate_inclusion_of(:reason).
        in_array(subject.reasons)
    end

    it do
      is_expected.
        to validate_inclusion_of(:has_destinations).
        in_array(subject.has_destinations_values)
    end

    context 'date' do
      context 'with a valid date' do
        it 'returns true' do
          params[:date] = '12/01/2016'
          expect(subject.validate(params)).to be true
        end
      end

      context 'with an invalid date' do
        it 'returns false' do
          params[:date] = 'invalid'
          expect(subject.validate(params)).to be false
        end

        it 'sets an error on date' do
          params[:date] = 'invalid'
          subject.validate(params)
          expect(subject.errors).to include :date
        end
      end
    end
  end

  describe '#deserialize' do
    it 'deserializes the form from the params' do
      coerced_params = params.merge(
        date: Date.civil(2017, 2, 1),
        destinations: [
          establishment: 'Hospital',
          must_return: 'must_return',
          reasons: 'Violence',
          _delete: false
        ]
      )

      subject.deserialize(params)
      expect(subject.to_nested_hash).to eq coerced_params
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes_without_nested_forms = subject.to_nested_hash.except(:destinations)
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes_without_nested_forms
    end

    it 'sets the data on nested models' do
      subject.validate(params)
      subject.save

      model_destinations = model.destinations.map(&:attributes)
      form_destinations = destinations_without_virtual_attributes(subject)

      model_destinations.each_with_index do |md, index|
        expect(md).to include form_destinations[index]
      end
    end

    def destinations_without_virtual_attributes(form)
      form.to_nested_hash[:destinations].each { |d| d.delete(:_delete) }
    end

    context 'removing destinations' do
      let(:params_with_destination_marked_for_delete) {
        {
          from: 'Bedford',
          to: 'Albany',
          date: '1/2/2017',
          reason: 'sentencing',
          has_destinations: 'yes',
          destinations: [
            establishment: 'Hospital',
            must_return: 'must_return',
            reasons: 'Violence',
            _delete: '1'
          ]
        }.with_indifferent_access
      }

      it 'doesnt pass the destination object to the model for saving' do
        subject.validate(params_with_destination_marked_for_delete)
        subject.save

        expect(model.destinations).to be_empty
      end

      context 'when has destinations is not set to yes' do
        it 'doesnt save the destination objects' do
          %w[ no unknown ].each do |has_destinations_value|
            params[:has_destinations] = has_destinations_value
            subject.validate(params)
            subject.save

            expect(model.destinations).to be_empty
          end
        end
      end
    end
  end

  describe '#prepopulate!' do
    context 'when destinations are empty' do
      it 'adds a new destination to the collection' do
        expect { subject.prepopulate! }.
          to change { subject.destinations.size }.from(0).to(1)
      end
    end

    context 'when at least one destination exists' do
      it 'it doesnt alter the collection' do
        subject.destinations << Destination.new
        expect { subject.prepopulate! }.
          not_to change { subject.destinations.size }
      end
    end
  end

  describe '#add_destination' do
    it 'adds a new destination to the collection' do
      expect { subject.add_destination }.
        to change { subject.destinations.size }.by(1)
    end
  end
end
