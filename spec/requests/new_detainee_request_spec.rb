require 'rails_helper'

RSpec.describe 'New detainee requests', type: :request do
  context 'when user is not authorized' do
    it 'redirects user to login page' do
      get '/detainees/new'
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
        get "/detainees/new?prison_number=#{prison_number}"
        expect(response).to redirect_to new_detainee_move_path(detainee)
      end
    end

    context 'when there is not a editable move' do
      it 'skips redirection to the home page' do
        get '/detainees/new'
        expect(response).not_to redirect_to root_path
      end
    end

    it 'does not set a flash error message if no prison number is provided' do
      get '/detainees/new'
      expect(flash[:warning]).to eq(nil)
    end

    context 'when a prison number is provided' do
      let(:prison_number) { 'ABC123' }
      let(:request_path) { "/detainees/new?prison_number=#{prison_number}" }

      before do
        stub_nomis_api_request(:get, "/offenders/#{prison_number}")
        stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: 'base64-image' }.to_json)
      end

      it 'does not set any flash error messages' do
        get request_path
        expect(flash[:warning]).to be_nil
      end

      context 'when detainee details cannot be prefetched' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 500)
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
        end

        it 'sets a flash error message indicating the details could not be prefetched' do
          get request_path
          expect(flash[:warning]).to include('Look-Up function is not currently available. Please enter person details manually or try again later')
        end
      end

      context 'when image details cannot be prefetched' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}")
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 500)
        end

        it 'sets a flash error message indicating the image could not be prefetched' do
          get request_path
          expect(flash[:warning]).to include('Image Look-Up function is not currently available. Please try again later')
        end
      end

      context 'when the provided prison number is invalid' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 400)
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 400)
        end

        it 'sets a flash error message indicating the provided prison number is invalid' do
          get request_path
          expect(flash[:warning]).to include('The provided prison number is not valid, please try again with a valid prison number')
        end
      end

      context 'when there are no records for the provided prison number' do
        let(:body) { [].to_json }

        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 404)
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 404)
        end

        it 'sets a flash error message indicating there no records in the API for the provided prison number' do
          get request_path
          expect(flash[:warning]).to include('No record for that prison reference exists. Please check the reference used or enter the details manually')
        end
      end

      context 'when image for the detainee cannot be found' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}")
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: nil }.to_json)
        end

        it 'sets a flash error message indicating the image was not found' do
          get request_path
          expect(flash[:warning]).to include('Look-Up function for photograph returned no image. Either try again later or attach photograph manually to print out')
        end
      end

      context 'when details api returns invalid json' do
        let(:body) { 'not-valid-json' }

        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}", body: body)
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
        end

        it 'sets a flash error message indicating the details could not be prefetched' do
          get request_path
          expect(flash[:warning]).to include('Look-Up function is not currently available. Please enter person details manually or try again later')
        end
      end

      context 'when image api returns invalid json' do
        let(:body) { 'not-valid-json' }

        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}")
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: body)
        end

        it 'sets a flash error message indicating the image could not be prefetched' do
          get request_path
          expect(flash[:warning]).to include('Image Look-Up function is not currently available. Please try again later')
        end
      end
    end
  end
end
