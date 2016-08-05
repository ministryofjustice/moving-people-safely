require 'rails_helper'

RSpec.describe Forms::Risk::Violence, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'violent' => 'yes',
      'other_detainees' => '1',
      'other_detainees_details' => 'Repeated fights',
    }
  }

  describe '#validate' do
    context "for the 'violent' attribute" do
      it { is_expected.to validate_optional_field(:violent) }

      # FIXME this is super hard to grok.. the validator is just complicating the spec
      it "resets all attributes unless the 'violent' toggle is enabled" do
        is_expected.to validate_attributes_are_reset(
          :prison_staff, :prison_staff_details, :risk_to_females, :risk_to_females_details,
          :escort_or_court_staff, :escort_or_court_staff_details, :healthcare_staff,
          :healthcare_staff_details, :other_detainees, :other_detainees_details, :homophobic,
          :homophobic_details, :racist, :racist_details, :public_offence_related,
          :public_offence_related_details, :police, :police_details
        ).when_attribute_is_disabled(:violent).with_attribute_value_set_as(true)
      end

      context 'when violent is set to yes' do
        before { subject.violent = 'yes' }

        %w[ prison_staff
          risk_to_females
          escort_or_court_staff
          healthcare_staff
          other_detainees
          homophobic
          racist
          public_offence_related
          police ].each do |field|
          context "when #{field} is set to true" do
            before { subject.public_send("#{field}=", true) }
            it { is_expected.to validate_presence_of("#{field}_details") }
          end
        end
      end
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
