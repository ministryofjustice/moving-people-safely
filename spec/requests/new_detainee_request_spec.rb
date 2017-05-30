require 'rails_helper'

RSpec.describe 'New detainee requests', type: :request do
  let(:prison_number) { 'ABC123' }
  let(:escort) { create(:escort, prison_number: prison_number) }

  context 'when user is not authorized' do
    it 'redirects user to login page' do
      get "/escorts/#{escort.id}/detainee/new"
      expect(response.status).to eq(302)
      expect(response).to redirect_to new_session_path
    end
  end

  context 'when user is authorized' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    context 'when there is no escort with the provided id' do
      it 'returns a 404 response' do
        expect {
          get "/escorts/#{SecureRandom.uuid}/detainee/new"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the escort already has an associated detainee' do
      let(:detainee) { create(:detainee, prison_number: prison_number) }
      let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee) }

      it 'redirects user to the new move page' do
        get "/escorts/#{escort.id}/detainee/new"
        expect(flash[:alert]).to eq('Detainee details for the PER already exist.')
        expect(response).to redirect_to new_escort_move_path(escort)
      end
    end

    context 'when the escort is no longer editable' do
      let(:escort) { create(:escort, :issued, prison_number: prison_number) }

      it 'redirection to the home page' do
        get "/escorts/#{escort.id}/detainee/new"
        expect(response).to redirect_to root_path
      end
    end

    context 'when the escort is still editable' do
      let(:prison_number) { 'ABC123' }

      before do
        stub_nomis_api_request(:get, "/offenders/#{prison_number}")
        stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: 'base64-image' }.to_json)
      end

      it 'does not set any flash error messages' do
        get "/escorts/#{escort.id}/detainee/new"
        expect(flash[:warning]).to be_nil
      end

      context 'when detainee details cannot be prefetched' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 500)
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
        end

        it 'sets a flash error message indicating the details could not be prefetched' do
          get "/escorts/#{escort.id}/detainee/new"
          expect(flash[:warning]).to include('Look-Up function is not currently available. Please enter person details manually or try again later')
        end
      end

      context 'when image details cannot be prefetched' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}")
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 500)
        end

        it 'sets a flash error message indicating the image could not be prefetched' do
          get "/escorts/#{escort.id}/detainee/new"
          expect(flash[:warning]).to include('Image Look-Up function is not currently available. Please try again later')
        end
      end

      context 'when the provided prison number is invalid' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}", status: 400)
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 400)
        end

        it 'sets a flash error message indicating the provided prison number is invalid' do
          get "/escorts/#{escort.id}/detainee/new"
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
          get "/escorts/#{escort.id}/detainee/new"
          expect(flash[:warning]).to include('No record for that prison reference exists. Please check the reference used or enter the details manually')
        end
      end

      context 'when image for the detainee cannot be found' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}")
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: nil }.to_json)
        end

        it 'sets a flash error message indicating the image was not found' do
          get "/escorts/#{escort.id}/detainee/new"
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
          get "/escorts/#{escort.id}/detainee/new"
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
          get "/escorts/#{escort.id}/detainee/new"
          expect(flash[:warning]).to include('Image Look-Up function is not currently available. Please try again later')
        end
      end
    end
  end
end
