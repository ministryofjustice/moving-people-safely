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

      context 'when detainee details cannot be prepopulated' do
        it 'sets a flash error message indicating the details could not be prefetched' do
          get "/escorts/#{escort.id}/detainee/new"
          expect(flash[:warning]).to eq('Look-Up function is not currently available. Please enter person details manually')
        end
      end
    end
  end
end
