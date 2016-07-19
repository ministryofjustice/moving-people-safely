RSpec.describe SummaryPresenter, type: :presenter do
  let(:model) { double(:model) }
  subject { described_class.new model }

  describe '#answer_for' do
    context 'when method on model returns unknown' do
      it 'returns styled missing text' do
        allow(model).to receive(:attribute).and_return('unknown')
        expect(subject.answer_for('attribute')).
          to eq "<span class='text-error'>Missing</span>"
      end
    end

    context 'when method on model returns nil' do
      it 'returns styled missing text' do
        allow(model).to receive(:attribute).and_return(nil)
        expect(subject.answer_for('attribute')).
          to eq "<span class='text-error'>Missing</span>"
      end
    end

    context 'when method on model returns no' do
      it "returns 'no' text" do
        allow(model).to receive(:attribute).and_return('no')
        expect(subject.answer_for('attribute')).to eq "No"
      end
    end

    context 'when method on model returns false' do
      it "returns 'no' text" do
        allow(model).to receive(:attribute).and_return(false)
        expect(subject.answer_for('attribute')).to eq "No"
      end
    end

    context 'when method on model returns true' do
      it "returns styled 'yes' text" do
        allow(model).to receive(:attribute).and_return(true)
        expect(subject.answer_for('attribute')).to eq "<b>Yes</b>"
      end
    end

    context 'when method on model returns a string' do
      it "returns humanized string" do
        allow(model).to receive(:attribute).and_return('high')
        expect(subject.answer_for('attribute')).to eq "<b>High</b>"
      end
    end
  end

  describe '#details_for' do
    context 'when model has a details field' do
      it 'returns the content of details field' do
        allow(model).to receive(:attribute_details).and_return('details field')
        expect(subject.details_for('attribute')).to eq 'details field'
      end
    end

    context 'when model does not have a details field' do
      it 'returns the content of details field' do
        expect(subject.details_for('attribute')).to be nil
      end
    end
  end
end
