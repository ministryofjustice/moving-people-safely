require 'rails_helper'

RSpec.describe 'View admin Movements', type: :request do
  let(:prison_number) { 'A1234BC' }

  let(:user) { create(:user, :prison) }
  let(:admin) { create(:user, :admin) }

  context 'when user is not authenticated' do
    it 'redirects the user to the login page' do
      get '/admin/movements/new'
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'when user is authenticated as regular user' do
    before { sign_in_prison(user) }

    it 'redirects the user to the root page with an alert' do
      get '/admin/movements/new'
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to be_present
    end
  end

  context 'when user is authenticated as an admin' do
    before { sign_in_admin admin }

    it 'works' do
      get '/admin/movements/new'
      expect(response).to have_http_status(200)
    end
  end
end
