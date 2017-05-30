require 'rails_helper'

RSpec.describe 'Edit detainee requests', type: :request do
  let(:prison_number) { 'ABC123' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee) }

  context 'when user is not authorized' do
    it 'redirects user to login page' do
      get "/escorts/#{escort.id}/detainee/edit"
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_session_path
    end
  end

  context 'when user is authorized' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    context 'when the escort for the provided id does not exist' do
      it 'raises a record not found error' do
        expect {
          get "/escorts/#{SecureRandom.uuid}/detainee/edit"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the escort is no longer editable' do
      let(:escort) { create(:escort, :issued) }

      it 'redirects to the homepage displaying an appropriate error' do
        get "/escorts/#{escort.id}/detainee/edit"
        expect(flash[:alert]).to eq('The PER can no longer be changed.')
        expect(response).to have_http_status(302)
      end
    end

    context 'when the detainee does not exist' do
      let(:escort) { create(:escort, prison_number: prison_number) }

      it 'raises a record not found error' do
        expect {
          get "/escorts/#{escort.id}/detainee/edit"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the detainee exists' do
      context 'and no pull option is provided' do
        it 'does not retrieve image from remote API' do
          expect(Nomis::Api.instance).not_to receive(:get).with("/offenders/#{prison_number}/image")
          get "/escorts/#{escort.id}/detainee/edit"
        end
      end

      context 'and option to pull image is provided' do
        let(:params) { { pull: :image } }

        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image")
        end

        it 'retrieves image from remote API' do
          expect(Nomis::Api.instance).to receive(:get).with("/offenders/#{prison_number}/image")
          get "/escorts/#{escort.id}/detainee/edit", params: params
        end

        context 'when image details cannot be prefetched' do
          before do
            stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 500)
          end

          it 'sets a flash error message indicating the image could not be prefetched' do
            get "/escorts/#{escort.id}/detainee/edit", params: params
            expect(flash[:warning]).to include('Image Look-Up function is not currently available. Please try again later')
          end
        end

        context 'when image for the detainee cannot be found' do
          before do
            stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: nil }.to_json)
          end

          it 'sets a flash error message indicating the image was not found' do
            get "/escorts/#{escort.id}/detainee/edit", params: params
            expect(flash[:warning]).to include('Look-Up function for photograph returned no image. Either try again later or attach photograph manually to print out')
          end
        end
      end
    end
  end
end
