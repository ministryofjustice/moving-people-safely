require 'rails_helper'

RSpec.describe Summary::SexOffencesPresenter, type: :presenter do
  let(:model) { instance_double(Risk, sex_offence: 'unknown') }
  subject { described_class.new(model) }

  # it already implements the answer_for method etc
  it { is_expected.to be_a SummaryPresenter }

  describe '#details_for' do
    describe 'accepts an argument in order to appear like a regular summary presenter' do
      it 'ignores the arg as the presenter is specific to sex offence' do
        expect(subject.details_for('ignored')).to be_nil
        expect(subject.details_for).to be_nil
      end
    end

    context 'when the sex offence attribute is no' do
      let(:model) { instance_double(Risk, sex_offence: 'no') }
      its(:details_for) { is_expected.to be_nil }
    end

    context 'when the sex offence attribute is unknown' do
      let(:model) { instance_double(Risk, sex_offence: 'unknown') }
      its(:details_for) { is_expected.to be_nil }
    end

    context 'when the sex offence attribute is yes' do
      let(:model) do
        instance_double(
          Risk,
          sex_offence: 'yes',
          sex_offence_victim: 'under_18',
          sex_offence_details: 'Details of the crime.'
        )
      end

      it 'returns the sex offence victim type & details' do
        expect(subject.details_for).to eq "Under 18. Details of the crime."
      end
    end
  end
end
