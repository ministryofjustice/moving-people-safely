require 'rails_helper'

RSpec.describe OffencesForm, type: :form do
  subject { described_class.new(Offences.new) }

  let(:form_data) do
    {
      'release_date' => release_date,
      'not_for_release' => true,
      'not_for_release_reason' => 'remember what happened last time?'
    }
  end

  let(:release_date) { '15/09/2027' }

  describe "#validate" do
    let(:result) { subject.validate(form_data) }

    it { is_expected.to validate_presence_of(:release_date) }
    it { is_expected.to validate_string_as_date(:release_date) }

    context "not_for_release" do
      context "accepts boolean" do

      end
    end
  end
end