require 'rails_helper'

RSpec.describe 'New detainee requests', type: :request do
  context 'when user is not authorized' do
    it 'redirects user to login page' do
      get '/detainee/new'
      expect(response.status).to eq(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when user is authorized' do
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in(user) }

    context 'when the detainee with the provided prison number already exists' do
      let(:prison_number) { 'ABC123' }
      let(:detainee) { FactoryGirl.create(:detainee, prison_number: prison_number) }

      before do
        detainee
      end

      it 'redirects user to the detainee move page' do
        get "/detainee/new?prison_number=#{prison_number}"
        expect(response).to redirect_to new_move_path(detainee)
      end
    end

    context 'when there is not a editable move' do
      it 'skips redirection to the home page' do
        get '/detainee/new'
        expect(response).not_to redirect_to root_path
      end
    end

    it 'does not set a flash error message if no prison number is provided' do
      get '/detainee/new'
      expect(flash[:warning]).to eq(nil)
    end

    context 'when a prison number is provided' do
      let(:prison_number) { 'ABC123' }
      let(:request_path) { "/detainee/new?prison_number=#{prison_number}" }

      context 'when detainee details cannot be prefetched' do
        before do
          stub_offenders_api_request(:get, '/offenders/search',
                                     with: { params: { noms_id: prison_number } },
                                     return: { body: {}, status: 201 })
        end

        it 'sets a flash error message indicating the details could not be prefetched' do
          get request_path
          expect(flash[:warning]).to eq('Look-Up function is not currently available. Please enter person details manually or try again later')
        end
      end

      context 'when there are no records for the provided prison number' do
        let(:body) { [].to_json }

        before do
          stub_offenders_api_request(:get, '/offenders/search',
                                     with: { params: { noms_id: prison_number } },
                                     return: { body: body, status: 200 })
        end

        it 'sets a flash error message indicating there no records in the API for the provided prison number' do
          get request_path
          expect(flash[:warning]).to eq('No record for that prison reference exists. Please check the reference used or enter the details manually')
        end
      end

      context 'when api returns invalid json' do
        let(:body) { 'not-valid-json' }

        before do
          stub_offenders_api_request(:get, '/offenders/search',
                                     with: { params: { noms_id: prison_number } },
                                     return: { body: body, status: 200 })
        end

        it 'sets a flash error message indicating the details could not be prefetched' do
          get request_path
          expect(flash[:warning]).to eq('Look-Up function is not currently available. Please enter person details manually or try again later')
        end
      end
    end
  end
end
