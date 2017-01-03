require 'rails_helper'

RSpec.describe ApiDetaineeDetailsMapper do
  let(:prison_number) { 'ABC123' }
  let(:given_name) { 'John' }
  let(:middle_names) { 'C.' }
  let(:surname) { 'Doe' }
  let(:date_of_birth) { '1969-01-23' }
  let(:gender) { 'm' }
  let(:nationality_code) { 'FR' }
  let(:pnc_number) { '12344' }
  let(:cro_number) { '54321' }
  let(:hash) {
    {
      'noms_id' => prison_number,
      'given_name' => given_name,
      'middle_names' => middle_names,
      'surname' => surname,
      'date_of_birth' => date_of_birth,
      'gender' => gender,
      'nationality_code' => nationality_code,
      'pnc_number' => pnc_number,
      'cro_number' => cro_number
    }
  }
  let(:expected_result) {
    {
      prison_number: prison_number,
      forenames: 'John C.',
      surname: 'Doe',
      date_of_birth: '23/01/1969',
      gender: 'male',
      nationalities: 'French',
      pnc_number: '12344',
      cro_number: '54321'
    }.with_indifferent_access
  }

  subject(:mapper) { described_class.new(prison_number, hash) }

  it 'returns a mapped hash with all the mandatory details' do
    result = mapper.call
    expected_result = {
      prison_number: prison_number,
      forenames: 'John C.',
      surname: 'Doe',
      date_of_birth: '23/01/1969',
      gender: 'male',
      nationalities: 'French',
      pnc_number: '12344',
      cro_number: '54321'
    }.with_indifferent_access
    expect(result).to eq(expected_result)
  end

  context 'when retrieved given name is empty' do
    let(:given_name) { nil }

    it 'returns the forenames containing only the middle names' do
      expect(mapper.call).to eq(expected_result.merge('forenames' => 'C.'))
    end
  end

  context 'when retrieved middle names is empty' do
    let(:middle_names) { '' }

    it 'returns the forenames containing only the given name' do
      expect(mapper.call).to eq(expected_result.merge('forenames' => 'John'))
    end
  end

  context 'when neither retrieved given name or middle names are present' do
    let(:given_name) { '' }
    let(:middle_names) { '' }

    it 'returns the forenames as nil' do
      expect(mapper.call).to eq(expected_result.merge('forenames' => nil))
    end
  end

  context 'when retrieved surname is nil' do
    let(:surname) { nil }

    it 'returns the surname as nil' do
      expect(mapper.call).to eq(expected_result.merge('surname' => nil))
    end
  end

  context 'when retrieved date of birth is nil' do
    let(:date_of_birth) { nil }

    it 'returns the date of birth as nil' do
      expect(mapper.call).to eq(expected_result.merge('date_of_birth' => nil))
    end
  end

  context 'when retrieved date of birth is invalid' do
    let(:date_of_birth) { 'not-a-date' }

    it 'returns the date of birth as nil' do
      expect(mapper.call).to eq(expected_result.merge('date_of_birth' => nil))
    end
  end

  context 'when retrieved gender is nil' do
    let(:gender) { nil }

    it 'returns the gender as nil' do
      expect(mapper.call).to eq(expected_result.merge('gender' => nil))
    end
  end

  context 'when retrieved gender is neither male or female' do
    let(:gender) { 'o' }

    it 'returns the gender as nil' do
      expect(mapper.call).to eq(expected_result.merge('gender' => nil))
    end
  end

  context 'when retrieved gender is male' do
    let(:gender) { 'm' }

    it 'returns the gender as male' do
      expect(mapper.call).to eq(expected_result.merge('gender' => 'male'))
    end
  end

  context 'when retrieved gender is female' do
    let(:gender) { 'f' }

    it 'returns the gender as female' do
      expect(mapper.call).to eq(expected_result.merge('gender' => 'female'))
    end
  end

  context 'when retrieved nationality code is empty' do
    let(:nationality_code) { '' }

    it 'returns the nationalities as nil' do
      expect(mapper.call).to eq(expected_result.merge('nationalities' => nil))
    end
  end

  context 'when retrieved nationality code is not recognizable' do
    let(:nationality_code) { 'RANDOM-NC' }

    it 'returns the nationality code' do
      expect(mapper.call).to eq(expected_result.merge('nationalities' => 'RANDOM-NC'))
    end
  end

  context 'when retrieved PNC number is empty' do
    let(:pnc_number) { nil }

    it 'returns the PNC number as nil' do
      expect(mapper.call).to eq(expected_result.merge('pnc_number' => nil))
    end
  end

  context 'when retrieved CRO number is empty' do
    let(:cro_number) { nil }

    it 'returns the CRO number as nil' do
      expect(mapper.call).to eq(expected_result.merge('cro_number' => nil))
    end
  end
end
