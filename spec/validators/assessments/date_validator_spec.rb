require 'rails_helper'

RSpec.describe Assessments::DateValidator do
  class TestDateValidatable
    include ActiveModel::Validations
    attr_accessor :test_attr

    def initialize(test_attr)
      @test_attr = test_attr
    end
  end

  let(:validatable) { TestDateValidatable.new(test_attr: '21/11/2016') }
  let(:options) { { format: '%Y %b %m', not_in_the_past: true, message: 'custom_message' } }
  subject(:validator) { described_class.new(validatable, :test_attr, options) }

  describe '#call' do
    let(:date_validator) { double(::DateValidator) }
    let(:validation_options) { options.merge(attributes: :test_attr) }

    it 'delegates the validation to the generic date validator' do
      expect(::DateValidator).to receive(:new).with(validation_options).and_return(date_validator)
      expect(date_validator).to receive(:validate).with(validator).and_return('date-validator-result')
      expect(validator.call).to eq('date-validator-result')
    end
  end
end
