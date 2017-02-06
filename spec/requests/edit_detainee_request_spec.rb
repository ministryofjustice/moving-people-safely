require 'rails_helper'

RSpec.describe 'New detainee requests', type: :request do
  let(:prison_number) { 'ABC123' }
  let(:detainee) { FactoryGirl.create(:detainee, prison_number: prison_number) }

  context 'when user is not authorized' do
    it 'redirects user to login page' do
      get "/detainees/#{detainee.id}/edit"
      expect(response.status).to eq(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when user is authorized' do
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in(user) }

    context 'when the detainee does not exist' do
      it 'raises a record not found error' do
        expect {
          get "/detainees/#{SecureRandom.uuid}/edit"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the detainee exists' do
      context 'and no pull option is provided' do
        it 'does not retrieve image from remote API' do
          expect(Nomis::Api.instance).not_to receive(:get).with("/offenders/#{prison_number}/image")
          get "/detainees/#{detainee.id}/edit"
        end
      end

      context 'and option to pull image is provided' do
        let(:params) { { pull: :image } }

        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
        end

        it 'retrieves image from remote API' do
          expect(Nomis::Api.instance).to receive(:get).with("/offenders/#{prison_number}/image")
          get "/detainees/#{detainee.id}/edit", params: params
        end

        context 'when image details cannot be prefetched' do
          before do
            stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 500)
          end

          it 'sets a flash error message indicating the image could not be prefetched' do
            get "/detainees/#{detainee.id}/edit", params: params
            expect(flash[:warning]).to include('Image Look-Up function is not currently available. Please try again later')
          end
        end

        context 'when image for the detainee cannot be found' do
          before do
            stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: nil }.to_json)
          end

          it 'sets a flash error message indicating the image was not found' do
            get "/detainees/#{detainee.id}/edit", params: params
            expect(flash[:warning]).to include('Look-Up function for photograph returned no image. Either try again later or attach photograph manually to print out')
          end
        end
      end
    end
  end
end
