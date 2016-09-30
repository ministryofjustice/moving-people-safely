require 'rails_helper'

RSpec.describe Considerations::OptionalDetails do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    let(:attrs) do
      {
        option: 'unknown',
        details: ''
      }
    end

    before { subject.properties = context_attrs  }

    context "with valid data" do
      let(:context_attrs) { attrs }

      it "returns true" do
        expect(subject).to be_valid
      end
    end

    context "with invalid data" do
      let(:context_attrs) { attrs.merge(option: 'yes') }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end

    context "with invalid data that needs resetting" do
      let(:context_attrs) { attrs.merge(option: 'no', details: 'frible') }

      it "returns true" do
        expect(subject).to be_valid
      end
    end
  end

  describe "#errors" do
    let(:attrs) do
      {
        option: 'no',
        details: ''
      }
    end

    before do
      subject.properties = context_attrs
      subject.validate
    end

    let(:result) { subject.errors.full_messages }

    context "details field" do
      context "when the details field is empty" do
        let(:context_attrs) { attrs.merge({option: 'yes'}) }

        it "Details must be filled" do
          expect(result).to eql ["Details must be filled"]
        end
      end

      context "when the details field is massive" do
        let(:context_attrs) { attrs.merge({option: 'yes', details: 'x' * 500}) }

        it "Details must be less than 200 characters" do
          expect(result).to eql ["Details size cannot be greater than 200"]
        end
      end
    end

    context "option field" do
      context "when the option field is missing" do
        let(:context_attrs) { {} }

        it "Options must be filled" do
          expect(result).to eql ["Option is missing"]
        end
      end

      context "when the option field is something random" do
        let(:context_attrs) { { option: 'hahalolhowrandom', details: 'asd' } }

        it "Option must be in list" do
          expect(result).to eql ["Option must be one of: yes, no, unknown"]
        end
      end
    end
  end

  describe '#reset' do
    context 'when the option is set to yes' do
      it 'empties the details property' do
        subject.properties = { option: 'yes', details: 'something' }
        expect { subject.reset }.not_to change { subject.details }
      end
    end

    context 'when the option is set to no' do
      it 'empties the details property' do
        subject.properties = { option: 'no', details: 'something' }
        expect { subject.reset }.to change { subject.details }.
          from('something').to('')
      end
    end

    context "when the consideration has been set with undesired properties" do
      it "filters these properties" do
        mal_params = { 'option' => 'no', 'mal_param' => '<script>' }
        subject.properties = mal_params
        expect { subject.reset }.to change { subject.properties }.
          from(mal_params).to({ 'option' => 'no', 'details' => '' })
      end
    end
  end
end
