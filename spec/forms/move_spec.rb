require 'rails_helper'

RSpec.describe Forms::Move, type: :form do
  let(:model) { Move.new }
  subject(:form) { described_class.new(model) }

  let(:params) {
    {
      from: 'Bedford',
      to: 'Albany',
      date: '1/2/2017',
      not_for_release: 'yes',
      not_for_release_reason: 'held_for_immigration',
      has_destinations: 'yes',
      destinations: [
        {
          establishment: 'Hospital',
          must_return: 'must_return',
          reasons: 'Not feeling good',
          _delete: '0'
        },
        {
          establishment: 'Tribunal',
          must_return: 'must_return',
          reasons: 'Sentence',
          _delete: '0'
        }
      ]
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:from) { is_expected.to eq 'HMP Bedford' }
    its(:has_destinations) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    it { is_expected.to validate_prepopulated_collection(:destinations, subform_class: Forms::Moves::Destination) }
    it { is_expected.to validate_optional_field(:has_destinations) }

    describe 'nilifies empty strings' do
      %w[from to].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    it 'coerces params' do
      coerced_params = params.merge(
        date: Date.civil(2017, 2, 1),
        destinations: [
          {
            establishment: 'Hospital',
            must_return: 'must_return',
            reasons: 'Not feeling good',
            _delete: false
          },
          {
            establishment: 'Tribunal',
            must_return: 'must_return',
            reasons: 'Sentence',
            _delete: false
          }
        ]
      )

      form.validate(params)
      expect(form.to_nested_hash).to eq coerced_params
    end

    context "for not for release" do
      it { is_expected.to validate_optional_field(:not_for_release) }

      shared_examples_for 'no validation on not for release reason' do
        it 'does not validate the reason (and details) for release' do
          form.valid?
          expect(form.errors.keys).not_to include(:not_for_release_reason)
          expect(form.errors.keys).not_to include(:not_for_release_reason_details)
        end
      end

      context 'when not for release is set to unknown' do
        before do
          form.not_for_release = 'unknown'
          form.not_for_release_reason = nil
          form.not_for_release_reason_details = nil
        end

        include_examples 'no validation on not for release reason'

        context 'and not for release reason is set to other' do
          before do
            form.not_for_release_reason = 'other'
          end

          include_examples 'no validation on not for release reason'
        end
      end

      context 'when not for release is set to no' do
        before do
          form.not_for_release = 'no'
          form.not_for_release_reason = nil
          form.not_for_release_reason_details = nil
        end

        include_examples 'no validation on not for release reason'

        context 'and not for release reason is set to other' do
          before do
            form.not_for_release_reason = 'other'
          end

          include_examples 'no validation on not for release reason'
        end
      end

      context 'when not for release is set to yes' do
        before { form.not_for_release = 'yes' }

        shared_examples_for 'invalid not for release reason' do
          it 'an inclusion error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to include(:not_for_release_reason)
            expect(form.errors[:not_for_release_reason]).to match_array([I18n.t(:inclusion, scope: 'errors.messages')])
          end
        end

        context 'but not reason is supplied' do
          before { form.not_for_release_reason = nil }
          include_examples 'invalid not for release reason'
        end

        context 'but an invalid reason is supplied' do
          before { form.not_for_release_reason = 'not-a-valid-one' }
          include_examples 'invalid not for release reason'
        end

        context 'reason supplied is valid' do
          before { form.not_for_release_reason = 'held_for_immigration' }

          specify {
            form.valid?
            expect(form.errors.keys).not_to include(:not_for_release_reason)
          }
        end

        context 'reason supplied requires extra details' do
          before do
            form.not_for_release_reason = 'other'
            form.not_for_release_reason_details = 'some details'
          end

          context 'and no details are provided' do
            before { form.not_for_release_reason_details = nil }

            it 'a presence error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to include(:not_for_release_reason_details)
              expect(form.errors[:not_for_release_reason_details]).to match_array([I18n.t(:blank, scope: 'errors.messages')])
            end
          end

          specify {
            form.valid?
            expect(form.errors.keys).not_to include(:not_for_release_reason_details)
          }
        end
      end
    end

    describe 'reset not for release associated information' do
      it { is_expected.to be_configured_to_reset(%i[not_for_release_reason not_for_release_reason_details]).when(:not_for_release).not_set_to('yes') }
    end

    describe 'reset not for release reason associated details' do
      it { is_expected.to be_configured_to_reset(%i[not_for_release_reason_details]).when(:not_for_release_reason).not_set_to('other') }
    end

    context 'date' do
      context 'with a valid date' do
        it 'returns true' do
          params[:date] = '12/01/2030'
          expect(form.validate(params)).to be true
        end
      end

      context 'with an invalid date' do
        it 'returns false' do
          params[:date] = 'invalid'
          expect(form.validate(params)).to be false
        end

        it 'sets an error on date' do
          params[:date] = 'invalid'
          form.validate(params)
          expect(form.errors).to include :date
        end
      end

      context "with a date in the past" do
        it 'returns false' do
          params[:date] = '01/01/2015'
          expect(form.validate(params)).to be false
        end

        it 'sets a descriptive error on date' do
          params[:date] = '01/01/2015'
          form.validate(params)
          expect(form.errors[:date]).to include 'must not be in the past.'
        end
      end
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      form.validate(params)
      form.save

      form_attributes_without_nested_forms = form.to_nested_hash.except(:destinations)
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes_without_nested_forms
    end

    it 'sets the data on nested models' do
      form.validate(params)
      form.save

      model_destinations = model.destinations.map(&:attributes)
      form_destinations = destinations_without_virtual_attributes(form)

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
        form.validate(params_with_destination_marked_for_delete)
        form.save

        expect(model.destinations).to be_empty
      end

      context 'when has destinations is not set to yes' do
        it 'doesnt save the destination objects' do
          %w[ no unknown ].each do |destination_value|
            params[:has_destinations] = destination_value
            form.validate(params)
            form.save

            expect(model.destinations).to be_empty
          end
        end
      end
    end
  end

  describe '#add_destination' do
    it 'adds a new destination to the collection' do
      expect { form.add_destination }.
        to change { form.destinations.size }.by(1)
    end
  end
end
