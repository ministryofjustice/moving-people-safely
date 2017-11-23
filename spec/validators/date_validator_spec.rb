require 'rails_helper'

RSpec.describe DateValidator do
  def validatable_klass(options = {})
    options = options.empty? ? true : options
    Class.new do
      def self.name
        'DateValidatable'
      end

      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :date
      validates :date, date: options
    end
  end

  let(:date) { '23/9/76' }
  subject { validatable_klass.new(date: date) }

  specify { is_expected.to be_valid }

  context 'when date value is already a date' do
    let(:date) { Date.new(1980, 2, 3) }
    specify { is_expected.to be_valid }
  end

  context 'when date is not valid' do
    let(:date) { 'not-a-date' }
    specify {
      is_expected.not_to be_valid
      expect(subject.errors[:date]).to match_array(['^Enter a valid Date'])
    }

    context 'with a custom error message' do
      let(:error_message) { 'custom error message' }
      subject { validatable_klass(message: error_message).new(date: date) }

      specify {
        is_expected.not_to be_valid
        expect(subject.errors[:date]).to match_array([error_message])
      }
    end
  end

  context 'when date is not in the default format' do
    let(:date) { '11-02-98' }
    specify {
      is_expected.not_to be_valid
      expect(subject.errors[:date]).to match_array(['^Enter a valid Date'])
    }
  end

  context 'when a custom format is provided' do
    let(:format) { '%d-%m-%Y' }
    subject { validatable_klass(format: format).new(date: date) }

    context 'and a date with the correct format is provided' do
      let(:date) { '11-02-98' }
      specify { is_expected.to be_valid }
    end

    context 'and a date with a different format is provided' do
      let(:date) { '11.02.98' }
      specify {
        is_expected.not_to be_valid
        expect(subject.errors[:date]).to match_array(['^Enter a valid Date'])
      }
    end
  end

  context 'when the date cannot be in the past' do
    subject { validatable_klass(not_in_the_past: true).new(date: date) }

    context 'and it is' do
      let(:date) { Time.current.yesterday.to_date }
      specify {
        is_expected.not_to be_valid
        expect(subject.errors[:date]).to match_array(['must not be in the past'])
      }

      context 'with a custom error message' do
        let(:error_message) { 'custom error message' }
        subject { validatable_klass(not_in_the_past: { message: error_message } ).new(date: date) }

        specify {
          is_expected.not_to be_valid
          expect(subject.errors[:date]).to match_array([error_message])
        }
      end
    end

    context 'and its not' do
      let(:date) { Date.current }
      specify { is_expected.to be_valid }
    end
  end

  context 'when the date cannot be in the future' do
    subject { validatable_klass(not_in_the_future: true).new(date: date) }

    context 'and it is' do
      let(:date) { Time.current.tomorrow.to_date }
      specify {
        is_expected.not_to be_valid
        expect(subject.errors[:date]).to match_array(['must not be in the future'])
      }

      context 'with a custom error message' do
        let(:error_message) { 'custom error message' }
        subject { validatable_klass(not_in_the_future: { message: error_message } ).new(date: date) }

        specify {
          is_expected.not_to be_valid
          expect(subject.errors[:date]).to match_array([error_message])
        }
      end
    end

    context 'and its not' do
      let(:date) { Date.current }
      specify { is_expected.to be_valid }
    end
  end
end
