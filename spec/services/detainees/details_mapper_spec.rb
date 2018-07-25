require 'rails_helper'

RSpec.describe Detainees::DetailsMapper do
  let(:prison_number) { 'ABC123' }
  let(:given_name) { 'John' }
  let(:middle_names) { 'C.' }
  let(:surname) { 'Doe' }
  let(:date_of_birth) { '1969-01-23' }
  let(:gender) { { 'code' => 'M', 'desc' => 'Male' } }
  let(:ethnicity) { { 'code' => 'EU', 'desc' => 'European' } }
  let(:religion) { { 'code' => 'B', 'desc' => 'Baptist' } }
  let(:nationalities) { 'French' }
  let(:language) { { 'preferred_spoken' => { 'code' => 'WEL-CYM', 'desc' => 'Welsh' }, 'interpreter_required' => false } }
  let(:diet) { { 'code' => 'GLU', 'desc' => 'Medical - Gluten Free Diet' } }
  let(:pnc_number) { '12344' }
  let(:cro_number) { '54321' }
  let(:security_category) { { 'code' => 'A', 'desc' => 'Category A' } }
  let(:aliases) {
    [
      { 'given_name' => 'James', 'surname' => 'Bond', 'date_of_birth' => '1969-01-24' },
      { 'given_name' => 'Tom', 'surname' => 'Ford', 'date_of_birth' => '1969-01-25' },
    ]
  }
  let(:hash) {
    {
      'noms_id' => prison_number,
      'given_name' => given_name,
      'middle_names' => middle_names,
      'surname' => surname,
      'date_of_birth' => date_of_birth,
      'gender' => gender,
      'ethnicity' => ethnicity,
      'religion' => religion,
      'nationalities' => nationalities,
      'language' => language,
      'diet' => diet,
      'pnc_number' => pnc_number,
      'cro_number' => cro_number,
      'aliases' => aliases,
      'security_category' => security_category
    }
  }
  let(:expected_result) {
    {
      prison_number: prison_number,
      forenames: 'JOHN C.',
      surname: 'DOE',
      date_of_birth: '23/01/1969',
      gender: 'male',
      ethnicity: 'European',
      religion: 'Baptist',
      nationalities: 'French',
      language: 'Welsh',
      interpreter_required: 'no',
      diet: 'Medical - Gluten Free Diet',
      pnc_number: '12344',
      cro_number: '54321',
      aliases: 'JAMES BOND, TOM FORD',
      security_category: 'Category A'
    }.with_indifferent_access
  }

  subject(:mapper) { described_class.new(prison_number, hash) }

  it 'returns a mapped hash with all the mandatory details' do
    result = mapper.call
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
      expect(mapper.call).to eq(expected_result.merge('forenames' => 'JOHN'))
    end
  end

  context 'when neither retrieved given name or middle names are present' do
    let(:given_name) { '' }
    let(:middle_names) { '' }

    it 'returns the forenames as nil' do
      expect(mapper.call).to eq(expected_result.merge('forenames' => nil))
    end
  end

  context 'when retrieved given name or middle names are not normalised' do
    let(:given_name) { 'McDonald' }
    let(:middle_names) { 'C.' }

    it 'returns the normalised forenames' do
      expect(mapper.call).to eq(expected_result.merge('forenames' => 'MCDONALD C.'))
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

  context 'when retrieved nationalities is empty' do
    let(:nationalities) { '' }

    it 'returns the nationalities as empty' do
      expect(mapper.call).to eq(expected_result.merge('nationalities' => ''))
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

  context 'when detainee has no aliases' do
    let(:aliases) { [] }

    it 'returns aliases as nil' do
      expect(mapper.call).to eq(expected_result.merge('aliases' => nil))
    end
  end

  context 'when detainee has an aliases without a surname' do
    let(:aliases) { [{ 'given_name' => 'James', 'middle_names' => 'C. Reilly', 'date_of_birth' => '1969-01-24' }] }

    it 'returns the remain names for that aliases' do
      expect(mapper.call).to eq(expected_result.merge('aliases' => 'JAMES C. REILLY'))
    end
  end

  context 'when detainee has an aliases without middle names' do
    let(:aliases) { [{ 'given_name' => 'James', 'surname' => 'Lovett', 'date_of_birth' => '1969-01-24' }] }

    it 'returns the remain names for that aliases' do
      expect(mapper.call).to eq(expected_result.merge('aliases' => 'JAMES LOVETT'))
    end
  end

  context 'when detainee has an aliases without given name' do
    let(:aliases) { [{ 'middle_names' => 'C. Reilly', 'surname' => 'Lovett', 'date_of_birth' => '1969-01-24' }] }

    it 'returns the remain names for that aliases' do
      expect(mapper.call).to eq(expected_result.merge('aliases' => 'C. REILLY LOVETT'))
    end
  end

  context 'when detainee has duplicate aliases' do
    let(:aliases) {
      [
        { 'given_name' => 'John', 'surname' => 'Unique' },
        { 'given_name' => 'Tom', 'surname' => 'Duplicate' },
        { 'given_name' => 'TOM', 'surname' => 'DUPLICATE' }
      ]
    }

    it 'returns a list of the unique aliases' do
      expect(mapper.call).to eq(expected_result.merge('aliases' => 'JOHN UNIQUE, TOM DUPLICATE'))
    end
  end

  context 'when retrieved interpreter_required is empty' do
    let(:language) { { 'preferred_spoken' => { 'code' => 'WEL-CYM', 'desc' => 'Welsh' } } }

    it 'returns the nationalities as empty' do
      expect(mapper.call).to eq(expected_result.merge('interpreter_required' => nil))
    end
  end

  context 'when retrieved interpreter_required is true' do
    let(:language) { { 'preferred_spoken' => { 'code' => 'WEL-CYM', 'desc' => 'Welsh' }, 'interpreter_required' => true } }

    it 'returns the nationalities as empty' do
      expect(mapper.call).to eq(expected_result.merge('interpreter_required' => 'yes'))
    end
  end

  context 'when retrieved interpreter_required is false' do
    let(:language) { { 'preferred_spoken' => { 'code' => 'WEL-CYM', 'desc' => 'Welsh' }, 'interpreter_required' => false } }

    it 'returns the nationalities as empty' do
      expect(mapper.call).to eq(expected_result.merge('interpreter_required' => 'no'))
    end
  end
end
