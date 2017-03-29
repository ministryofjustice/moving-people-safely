require 'rails_helper'

RSpec.describe 'Detainee image requests', type: :request do
  let(:prison_number) { 'ABC123' }
  let(:detainee) { FactoryGirl.create(:detainee, prison_number: prison_number) }

  context 'when user is not authorized' do
    it 'redirects user to login page' do
      get "/detainees/#{detainee.id}/image"
      expect(response.status).to eq(302)
      expect(response).to redirect_to new_session_path
    end
  end

  context 'when user is authorized' do
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in(user) }

    context 'when the detainee does not exist' do
      it 'raises a record not found error' do
        expect {
          get "/detainees/#{SecureRandom.uuid}/image"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the detainee exists' do
      context 'but there is no image for detainee' do
        before do
          detainee.image = nil
          detainee.save
        end

        it 'render a 404' do
          get "/detainees/#{detainee.id}/image"
          expect(response.status).to eq(404)
        end
      end

      context 'when the format provided is not valid' do
        it 'render a 404' do
          expect {
            get "/detainees/#{detainee.id}/image.gif"
          }.to raise_error(ActionController::RoutingError)
        end
      end

      context 'and there is an image for detainee' do
        before do
          detainee.image = 'some-base64-encoded-image'
          detainee.save
        end

        it 'render a 200' do
          get "/detainees/#{detainee.id}/image"
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
