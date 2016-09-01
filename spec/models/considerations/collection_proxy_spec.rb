require 'rails_helper'

RSpec.describe Considerations::CollectionProxy do

  class FakeConsideration < Consideration
    def schema
      Dry::Validation.Form { required(:baz).filled }
    end
  end

  subject { described_class.new('test', models) }

  describe '#assign_attributes' do
    let(:foo) { FakeConsideration.build(name: 'foo') }
    let(:bar) { FakeConsideration.build(name: 'bar') }

    let(:models) { [foo, bar] }

    let(:params) do
      { foo: { baz: 'something' }, bar: { baz: 'else' } }
    end

    it 'mass assigns attributes on the instance' do
      subject.assign_attributes(params)

      expect(subject.foo.baz).to eq 'something'
      expect(subject.bar.baz).to eq 'else'
    end
  end

  let(:invalid_model) { FakeConsideration.build(name: 'invalid') }
  let(:valid_foo_model) { FakeConsideration.build(name: 'foo').tap { |fc| fc.baz = 'some' } }
  let(:valid_bar_model) { FakeConsideration.build(name: 'bar').tap { |fc| fc.baz = 'text' } }

  describe '#valid?' do
    context 'when all of the underlying mdoels are valid' do
      let(:models) { [valid_foo_model, valid_bar_model] }
      it { is_expected.to be_valid }
    end

    context 'when atleast one of the underlying mdoels is invalid' do
      let(:models) { [invalid_model, valid_bar_model] }
      it { is_expected.to be_invalid }
    end
  end

  describe '#errors' do
    context 'when at least one of the underlying mdoels is invalid' do
      let(:models) { [invalid_model, valid_bar_model] }

      it 'contains errors that are namespaced according to their origin' do
        subject.valid?
        expect(subject.errors[:'invalid.baz']).to be_present
        expect(subject.errors[:'bar.baz']).not_to be_present
      end
    end

    context 'when all of the underlying models are valid' do
      let(:models) { [valid_foo_model, valid_bar_model] }

      it 'has no errors' do
        expect(subject.errors.none?).to be true
      end
    end
  end

  describe '#save!' do
    context 'with valid models' do
      let(:models) { [valid_foo_model, valid_bar_model] }

      it 'persists each model' do
        expect { subject.save! }.
          to change { valid_foo_model.persisted? && valid_bar_model.persisted? }.
          from(false).to(true)
        expect(valid_foo_model).to have_attributes(properties: { "baz" => "some" })
        expect(valid_bar_model).to have_attributes(properties: { "baz" => "text" })
      end
    end

    context 'is ran in a DB transaction' do
      context 'with invalid models' do
        let(:models) { [invalid_model, valid_bar_model] }

        it 'raises an exception not persisting any of the models' do
          expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
          expect(invalid_model.persisted? && valid_bar_model.persisted?).to be false
        end
      end
    end
  end
end
