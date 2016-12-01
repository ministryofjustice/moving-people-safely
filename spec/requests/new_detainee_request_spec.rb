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
  end
end
