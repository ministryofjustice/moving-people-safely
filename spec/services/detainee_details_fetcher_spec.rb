require 'rails_helper'

RSpec.describe DetaineeDetailsFetcher do
  let(:prison_number) { 'ABC123' }
  subject(:fetcher) { described_class.new(prison_number) }

  shared_examples_for 'empty response without API calls' do
    specify { expect(fetcher.call).to eq({}) }

    it 'does not call the Offenders API' do
      expect(Rails.offenders_api_client).not_to receive(:get)
      fetcher.call
    end
  end

  shared_examples_for 'request to Offenders API' do
    it 'calls the Offenders API' do
      expect(Rails.offenders_api_client)
        .to receive(:get)
        .with('/offenders/search', params: { noms_id: prison_number})
      fetcher.call
    end
  end

  context 'when prison number is nil' do
    let(:prison_number) { nil }
    include_examples 'empty response without API calls'
  end

  context 'when prison number is blank' do
    let(:prison_number) { '' }
    include_examples 'empty response without API calls'
  end

  context 'when Offenders API response is not 200' do
    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { status: 201 })
    end

    include_examples 'request to Offenders API'

    specify { expect(fetcher.call).to eq({}) }
  end

  context 'when Offenders API response does not contain a valid JSON response' do
    let(:invalid_body) { {}.to_json }
    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { body: invalid_body, status: 200 })
    end

    include_examples 'request to Offenders API'

    specify { expect(fetcher.call).to eq({}) }
  end

  context 'when Offenders API response contains a valid JSON response' do
    let(:given_name) { 'John' }
    let(:middle_names) { 'C.' }
    let(:surname) { 'Doe' }
    let(:date_of_birth) { '1969-01-23' }
    let(:gender) { 'm' }
    let(:nationality_code) { 'FR' }
    let(:pnc_number) { '12344' }
    let(:cro_number) { '54321' }
    let(:valid_body) {
      [{
        noms_id: prison_number,
        given_name: given_name,
        middle_names: middle_names,
        surname: surname,
        date_of_birth: date_of_birth,
        gender: gender,
        nationality_code: nationality_code,
        pnc_number: pnc_number,
        cro_number: cro_number
      }].to_json
    }

    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { body: valid_body, status: 200 })
    end

    include_examples 'request to Offenders API'

    it 'returns a mapped hash for the detainee data retrieved' do
      expected_response = {
        prison_number: prison_number,
        forenames: 'John C.',
        surname: 'Doe',
        date_of_birth: '23/01/1969',
        gender: 'male',
        nationalities: 'French',
        pnc_number: '12344',
        cro_number: '54321'
      }.with_indifferent_access
      expect(fetcher.call).to eq(expected_response)
    end

    context 'when retrieved given name is empty' do
      let(:given_name) { nil }

      it 'returns the forenames containing only the middle names' do
        response = fetcher.call
        expect(response[:forenames]).to eq('C.')
      end
    end

    context 'when retrieved middle names is empty' do
      let(:middle_names) { '' }

      it 'returns the forenames containing only the given name' do
        response = fetcher.call
        expect(response[:forenames]).to eq('John')
      end
    end

    context 'when neither retrieved given name or middle names are present' do
      let(:given_name) { '' }
      let(:middle_names) { '' }

      it 'returns the forenames as nil' do
        response = fetcher.call
        expect(response[:forenames]).to eq(nil)
      end
    end

    context 'when retrieved surname is nil' do
      let(:surname) { nil }

      it 'returns the surname as nil' do
        response = fetcher.call
        expect(response[:surname]).to eq(nil)
      end
    end

    context 'when retrieved date of birth is nil' do
      let(:date_of_birth) { nil }

      it 'returns the date of birth as nil' do
        response = fetcher.call
        expect(response[:date_of_birth]).to eq(nil)
      end
    end

    context 'when retrieved date of birth is invalid' do
      let(:date_of_birth) { 'not-a-date' }

      it 'returns the date of birth as nil' do
        response = fetcher.call
        expect(response[:date_of_birth]).to eq(nil)
      end
    end

    context 'when retrieved gender is nil' do
      let(:gender) { nil }

      it 'returns the gender as nil' do
        response = fetcher.call
        expect(response[:gender]).to eq(nil)
      end
    end

    context 'when retrieved gender is neither male or female' do
      let(:gender) { 'o' }

      it 'returns the gender as nil' do
        response = fetcher.call
        expect(response[:gender]).to eq(nil)
      end
    end

    context 'when retrieved gender is male' do
      let(:gender) { 'm' }

      it 'returns the gender as male' do
        response = fetcher.call
        expect(response[:gender]).to eq('male')
      end
    end

    context 'when retrieved gender is female' do
      let(:gender) { 'f' }

      it 'returns the gender as female' do
        response = fetcher.call
        expect(response[:gender]).to eq('female')
      end
    end

    context 'when retrieved nationality code is empty' do
      let(:nationality_code) { '' }

      it 'returns the nationalities as nil' do
        response = fetcher.call
        expect(response[:nationalities]).to eq(nil)
      end
    end

    context 'when retrieved nationality code is not recognizable' do
      let(:nationality_code) { 'RANDOM-NC' }

      it 'returns the nationality code' do
        response = fetcher.call
        expect(response[:nationalities]).to eq('RANDOM-NC')
      end
    end

    context 'when retrieved PNC number is empty' do
      let(:pnc_number) { nil }

      it 'returns the PNC number as nil' do
        response = fetcher.call
        expect(response[:pnc_number]).to eq(nil)
      end
    end

    context 'when retrieved CRO number is empty' do
      let(:cro_number) { nil }

      it 'returns the CRO number as nil' do
        response = fetcher.call
        expect(response[:cro_number]).to eq(nil)
      end
    end
  end
end
