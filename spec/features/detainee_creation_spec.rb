require 'feature_helper'

RSpec.feature 'Detainee creation', type: :feature do
  let(:prison_number) { 'AB123' }

  context 'when detainee prison number is not provided' do
    scenario 'filling detainee details manually' do
      login

      visit new_detainee_path
      new_detainee_page.assert_unprefilled_form
    end
  end

  context 'when detainee pre-filled information cannot be retrieved' do
    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { body: {}, status: 201 })
    end

    scenario 'filling detainee details manually' do
      login

      visit new_detainee_path(prison_number: prison_number)
      new_detainee_page.assert_unprefilled_form(prison_number)
    end
  end

  context 'when detainee pre-filled information is retrieved' do
    let(:successful_body) {
      [
        {
          noms_id: prison_number,
          given_name: 'John',
          middle_names: 'C.',
          surname: 'Doe',
          date_of_birth: '11-09-1975',
          gender: 'M',
          nationality_code: 'GB',
          pnc_number: '12345',
          cro_number: '112233'
        }
      ].to_json
    }
    let(:expected_field_values) {
      {
        surname: 'Doe',
        forenames: 'John C.',
        date_of_birth: '11/09/1975',
        nationalities: 'British',
        gender: 'male',
        pnc_number: '12345',
        cro_number: '112233'
      }
    }

    before do
      stub_offenders_api_request(:get, '/offenders/search',
                                 with: { params: { noms_id: prison_number } },
                                 return: { body: successful_body, status: 200 })
    end

    scenario 'filling detainee details manually' do
      login

      visit new_detainee_path(prison_number: prison_number)
      new_detainee_page.assert_prefilled_form(expected_field_values)
    end
  end
end
