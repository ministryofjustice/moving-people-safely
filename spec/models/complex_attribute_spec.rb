require 'rails_helper'

RSpec.describe ComplexAttribute do

  describe '<=>' do
    let(:params) { { a: 'bla', b: 'bar', c: '', d: nil } }
    subject(:attribute) { described_class.new(params) }

    context 'when the two objects do not contain the same attributes' do
      let(:other_attribute) { described_class.new(a: 'bla', b: 'bar') }
      specify { expect(attribute <=> other_attribute).to be_falsey }
    end

    context 'when the two objects contain the same attributes but with different values' do
      let(:other_attribute) { described_class.new(a: 'other', b: 'value', c: 'foo', d: 'bla') }
      specify { expect(attribute <=> other_attribute).to be_falsey }
    end

    context 'when the two objects contain the same attributes with the same values' do
      let(:other_attribute) { described_class.new(params) }
      specify { expect(attribute <=> other_attribute).to be_truthy }
    end

    context 'ignores any delete keys for the purpose of comparision' do
      let(:other_params) { { a: 'bla', b: 'bar', c: '', d: nil, _delete: '1' } }
      let(:other_attribute) { described_class.new(other_params) }
      specify { expect(attribute <=> other_attribute).to be_truthy }
    end
  end
end
