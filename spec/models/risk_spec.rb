require 'rails_helper'

RSpec.describe Risk, type: :model do
  describe "instance methods" do
    subject { described_class.new }

    it { is_expected.to belong_to(:detainee) }
    it_behaves_like 'questionable'

    describe "#question_fields" do
      let(:result) { subject.question_fields }

      it "returns all the considerations for this model instance" do
        expect(result).to match_array %i[ open_acct suicide rule_45 csra verbal_abuse physical_abuse violent
          stalker_harasser_bully sex_offence non_association_markers
          current_e_risk category_a
          restricted_status substance_supply substance_use conceals_weapons arson
          damage_to_property interpreter_required hearing_speach_sight
          can_read_and_write ]
      end
    end

    describe "#violent_on?" do
      let(:result) { subject.violent_on? }

      context "when the violent field is set to 'yes'" do
        before { subject.violent = 'yes' }

        it "returns true" do
          expect(result).to be true
        end
      end

      context "when the violent field is set to 'no'" do
        before { subject.violent = 'no' }

        it "returns false" do
          expect(result).to be false
        end
      end
    end

    describe "#on_values_for" do
      let(:result) { subject.on_values_for(field) }

      context "ternary" do
        let(:field) { :verbal_abuse }

        it "returns the standard ternary ['yes']" do
          expect(result).to eql verbal_abuse: ['yes']
        end
      end

      context "boolean" do
        let(:field) { :stalker }

        it "returns the standard boolean [true]" do
          expect(result).to eql stalker: [true]
        end
      end

      context "csra" do
        let(:field) { :csra }

        it "returns the special CSRA case of ['high']" do
          expect(result).to eql csra: ['high']
        end
      end

      context "sex_offence_victim" do
        let(:field) { :sex_offence_victim }

        it "returns the special Sex Offence case of ['under_18']" do
          expect(result).to eql sex_offence_victim: ['under_18']
        end
      end

      context "with an array of fields" do
        let(:field) { [:current_e_risk, :hostage_taker, :sex_offence_victim] }

        it "returns the on_values for each item in the input array" do
          expect(result).to eql ({
            current_e_risk: ['yes'],
            hostage_taker: [true],
            sex_offence_victim: ['under_18']
          })
        end
      end
    end
  end

  describe "class methods" do
    subject { described_class }

    describe ".children_of(:violent)" do
      let(:result) { subject.children_of(:violent) }

      it "returns all the direct child fields of the named branch" do
        expect(result).to match_array %i[ prison_staff risk_to_females escort_or_court_staff
          healthcare_staff other_detainees homophobic racist public_offence_related police ]
      end
    end

    describe ".children_of(:violent, recursive: true)" do
      let(:result) { subject.children_of(:violent, recursive: true) }

      it "recursively queries all the children and childrens children etc of the named branch" do
        expect(result).to match_array %i[
          prison_staff prison_staff_details risk_to_females risk_to_females_details
          escort_or_court_staff escort_or_court_staff_details healthcare_staff
          healthcare_staff_details other_detainees other_detainees_details homophobic
          homophobic_details racist racist_details public_offence_related
          public_offence_related_details police police_details
        ]
      end
    end

    describe "./field/_on_values" do
      it "returns an array of values" do
        expect(subject.violent_on_values).to eql ['yes']
      end
    end
  end
end
