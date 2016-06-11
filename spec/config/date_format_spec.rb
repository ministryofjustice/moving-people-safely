require 'rails_helper'

RSpec.describe 'custom date formats', type: :config do
  describe 'default date format' do
    it 'returns a date in the format DD/MM/YYYY' do
      example_date = Date.civil(1940, 3, 10)
      expect(example_date.to_s).to eq '10/03/1940'
    end
  end
end
