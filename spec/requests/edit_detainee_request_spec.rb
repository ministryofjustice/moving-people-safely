require 'rails_helper'

RSpec.describe 'Edit detainee requests', type: :request do
  let(:prison_number) { 'ABC123' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee) }
  let!(:move) { create(:move, escort: escort) }

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
  end
end
