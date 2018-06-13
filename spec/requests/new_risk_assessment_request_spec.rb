require 'rails_helper'

RSpec.describe 'New risk assessment requests', type: :request do
  let(:prison_number) { 'A1234BC' }
  let(:escort) { create(:escort, prison_number: prison_number) }

  context 'when user is not autenticated' do
    it 'redirects the user to the login page' do
      get "/escorts/#{escort.id}/risk/new"
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'when user is autenticated' do
    before { sign_in create(:user) }

    context 'but the escort with provided id does not exist' do
      it 'raises a record not found error' do
        expect {
          get "/escorts/#{SecureRandom.uuid}/risk/new"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'but there is already a risk assessment for the escort' do
      let(:risk) { create(:risk) }
      let(:escort) { create(:escort, prison_number: prison_number, risk: risk) }

      it 'redirects the user back to the escort page' do
        get "/escorts/#{escort.id}/risk/new"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(escort_risks_path(escort))
      end
    end
  end
end
